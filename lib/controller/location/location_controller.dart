import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:beat_flutter/controller/pedometer/pedometer_controller.dart';
import 'package:beat_flutter/managers/background_service/background_service_entry.dart';
import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/logger/beat_logger.dart';
import 'package:beat_flutter/managers/notification/local_notification.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LatLng {
  final double lat;
  final double lng;

  LatLng(this.lat, this.lng);
}

class LocationController extends GetxController {
  // iOS 네이티브와 통신하기 위한 MethodChannel
  // 모든 백그라운드 작업(걸음 수 동기화, 랭킹 집계, 자정 초기화)이 이 채널을 통해 이루어짐
  static const _channel = MethodChannel("com.beat.walkreport/channel");

  LocationController();

  // 위치
  final Rx<LatLng?> _locationData = Rx<LatLng?>(null);

  LatLng? get locationData => _locationData.value;

  set locationData(LatLng? value) => _locationData.value = value;

  bool get hasLocation => locationData != null;

  // 언어
  final LocalizationManager localizationManager = LocalizationManager();

  // 지속적으로 사용자 위치를 갱신해 유효 범위 내에 있는지를 확인하기 위한 타이머
  Timer? _timer;

  /// [_midnightTimer] : 매일 자정에 걸음 수 초기화
  Timer? _midnightTimer;

  /// [_eventDurationTimer] : 이벤트 진행 시간 측정용 타이머
  final int endHour = 18;
  final int endMinute = 0;
  final int endSecond = 0;
  Timer? _eventDurationTimer;

  bool isLocationPermissionDenied = true;

  Future<bool> getIsHoliday() async {
    final DateTime now = DateTime.now();
    final String requestUrl =
        "${DotEnvManager().holidayList}?year=${now.year}&month=${(now.month).toString().padLeft(2, "0")}";

    try {
      final http.Response response = await http
          .get(Uri.parse(requestUrl))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final List<dynamic> responseBody = jsonDecode(response.body);
        final String nowFormatted = DateFormat("yyyy-MM-dd").format(now);
        return (responseBody.any((e) => e["date"] == nowFormatted)) || now == DateTime.saturday || now == DateTime.sunday;
      }
      return now == DateTime.saturday || now == DateTime.sunday;
    } catch (e) {
      log("LocationController : getIsHoliday error : ${e.toString()}");
      return now == DateTime.saturday || now == DateTime.sunday;
    }
  }

  /// 서비스 초기화
  Future<void> initializeService() async {
    final service = FlutterBackgroundService();
    await service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: locationServiceStart,
        onBackground: locationServiceIosBackground,
      ),
      androidConfiguration: AndroidConfiguration(
        autoStart: false,
        onStart: locationServiceStart,
        isForegroundMode: false,
        autoStartOnBoot: false,
      ),
    );
  }

  /// iOS MethodChannel 핸들러
  void setMethodCallHandler() {
    if (Platform.isIOS) {
      _channel.setMethodCallHandler(
        (call) async {
          switch (call.method) {
            case "backgroundLocationUpdate":
              final args = call.arguments as Map?;
              if (args == null) return;
              final double lat = args["latitude"];
              final double lon = args["longitude"];
              checkIsValidAreaIOSBackground(lat, lon);
              break;

            case "midnightReset":
              _resetAtMidnight();
              break;

            case "eventDurationReset":
              // Get.find<PedometerController>().isEventDuration = false;
              // _stopEventTimers();
              break;

            // iOS 네이티브에서 정확한 시간에 호출되는 백그라운드 작업들
            case "syncWalkDataInBackground":
              await _syncWalkDataInBackground();
              break;

            case "syncRankingInBackground":
              await _syncRankingInBackground();
              break;
          }
        },
      );
    }
  }

  void startBackgroundService() async {
    final service = FlutterBackgroundService();
    setMethodCallHandler();

    final PedometerController pedometerController =
        Get.isRegistered<PedometerController>()
            ? Get.find<PedometerController>()
            : Get.put(PedometerController(), permanent: true);

    final bool isHoliday = await getIsHoliday();

    pedometerController.isHoliday = isHoliday;
    final int sendToTime = pedometerController.sendToTime;
    log("LocationController : startBackgroundService : isHoliday : $isHoliday, sendToTime : $sendToTime");

    if (Platform.isIOS) {
      // iOS 네이티브에 공휴일 여부 전달
      await _channel
          .invokeMethod("startBackgroundTasks", {"isHoliday": isHoliday, "sendToTime": sendToTime});
    } else {
      // Android는 그냥 서비스만 시작
      service.startService();
    }

    service.startService();
  }

  void stopBackgroundService() {
    final service = FlutterBackgroundService();
    service.invoke("stop");

    _channel.setMethodCallHandler(null);
    _stopAllTimers();
  }

  /// 자정 초기화
  void _resetAtMidnight() async {
    BEATLogger.d("LocationController : _resetAtMidnight() 시작");
    final bool isHoliday = await getIsHoliday();
    final pedometerController = Get.find<PedometerController>();

    BEATLogger.d("LocationController : 공휴일 여부: $isHoliday");
    
    pedometerController.isHoliday = isHoliday;
    pedometerController.isEventDuration = true;
    pedometerController.resetAtMidnight(DateTime.now());
    
    BEATLogger.d("LocationController : 걸음 수 초기화 완료");

    if (Platform.isIOS) {
      await _channel
          .invokeMethod("updateHolidayStatus", {"isHoliday": isHoliday});
      BEATLogger.d("LocationController : iOS 네이티브에 공휴일 상태 업데이트 완료");
    }

    // ✅ 공휴일이면 위치 추적/이벤트 타이머 중단
    if (isHoliday) {
      _stopEventTimers();
      BEATLogger.d("LocationController : 공휴일로 인해 이벤트 타이머 중단");
      return;
    }

    _startLocationTimer();
    BEATLogger.d("LocationController : 자정 초기화 완료 - 위치 추적 재시작");
    // _startEventDurationTimer();
  }

  /// Foreground 서비스 시작
  @pragma('vm:entry-point')
  void startTimer(ServiceInstance service) async {
    BEATLogger.d("LocationController : startTimer()");

    await EasyLocalization.ensureInitialized();

    final bool isHoliday = await getIsHoliday();

    final pedometerController = Get.isRegistered<PedometerController>()
        ? Get.find<PedometerController>()
        : Get.put(PedometerController(), permanent: true);

    pedometerController.isHoliday = isHoliday;

    _stopAllTimers();

    // iOS에서는 네이티브에서 정확한 시간에 작업을 수행하므로 타이머 사용하지 않음
    if (Platform.isIOS) {
      BEATLogger.d("LocationController : iOS에서는 네이티브 스케줄링 시스템 사용");
      // 공휴일이 아니면 위치 추적만 시작
      if (!isHoliday) {
        _startLocationTimer();
      }
    } else {
      // Android에서는 기존 타이머 방식 사용
      if (!isHoliday) {
        _startLocationTimer();
        // _startEventDurationTimer();
      }
      _startMidnightTimer();
    }
  }

  void _startLocationTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (t) async {
      if (isLocationPermissionDenied) return;
      await fetchLocation();
      checkIsValidArea();
    });
  }

  void _startEventDurationTimer() {
    final now = DateTime.now();

    if (now.hour < endHour &&
        now.minute < endMinute &&
        now.second < endSecond) {
      LocalNotificationManager.showNotification(
        localizationManager.lnEventDuration,
        localizationManager.lnBackInRangeBody,
      );
    }

    _eventDurationTimer = Timer.periodic(const Duration(seconds: 1), (t) async {
      if (now.hour > endHour ||
          (now.hour == endHour && now.minute > endMinute) ||
          (now.hour == endHour &&
              now.minute == endMinute &&
              now.second >= endSecond)) {
        Get.find<PedometerController>().isEventDuration = false;
        _stopEventTimers();
        LocalNotificationManager.showNotification(
          localizationManager.lnEventDurationEnded,
          localizationManager.lnOutOfRangeBody,
        );
      }
    });
  }

  void _startMidnightTimer() {
    _midnightTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      if (now.hour == 0 && now.minute == 0 && now.second == 0) {
        // if (now.hour == 19 && now.minute == 33 && now.second == 0) {
        log("resetAtMidnight()");
        _resetAtMidnight();
      }
    });
  }

  void _stopEventTimers() {
    _timer?.cancel();
    _timer = null;
    _eventDurationTimer?.cancel();
    _eventDurationTimer = null;
  }

  void _stopAllTimers() {
    _stopEventTimers();
    _midnightTimer?.cancel();
    _midnightTimer = null;
  }

  // 위치 관련
  Future<void> setUp() async {
    if (isLocationPermissionDenied) return;

    final now = DateTime.now();
    // if (now.hour > endHour ||
    //     (now.hour == endHour && now.minute > endMinute) ||
    //     (now.hour == endHour &&
    //         now.minute == endMinute &&
    //         now.second >= endSecond)) {
    //   Get.find<PedometerController>().isEventDuration = false;
    //   _stopEventTimers();
    //   LocalNotificationManager.showNotification(
    //     localizationManager.lnEventDurationEnded,
    //     localizationManager.lnOutOfRangeBody,
    //   );
    // }

    await fetchLocation();
    checkIsValidArea();
  }

  Future<void> fetchLocation() async {
    if (isLocationPermissionDenied) return;
    final location = Location();
    final newLocationData = await location.getLocation();
    if (newLocationData.latitude == null || newLocationData.longitude == null) {
      return;
    }
    locationData =
        LatLng(newLocationData.latitude!, newLocationData.longitude!);
  }

  List<LatLng> asanArea = [
    LatLng(36.73905847633573, 127.07441645479297),
    LatLng(36.73912287279299, 127.07227801510604),
    LatLng(36.73684411973639, 127.07046772248447),
    LatLng(36.73573576644016, 127.07042192605417),
    LatLng(36.73516838296647, 127.06987281506066),
    LatLng(36.73499676688655, 127.07055560002914),
    LatLng(36.73551867439705, 127.07179881381333),
    LatLng(36.735284149061435, 127.07218485008256),
    LatLng(36.73539632511584, 127.07294626975272),
    LatLng(36.73460225454914, 127.07469204585705),
    LatLng(36.73360175547217, 127.07509411621912),
    LatLng(36.7326814599723, 127.07689568084213),
    LatLng(36.73303259290043, 127.07736624033019),
    LatLng(36.73454715737327, 127.07631536610076),
    LatLng(36.736222818531225, 127.07697758417414),
    LatLng(36.73880014890887, 127.07678982054752),
    LatLng(36.738827370019735, 127.07649874382037),
    LatLng(36.7393687288168, 127.07542442851555),
    LatLng(36.739477490720276, 127.07442805567023),
  ];

  List<LatLng> cheonanArea = [
    LatLng(36.830327274558805, 127.18020021753239),
    LatLng(36.83009097680529, 127.18003992692661),
    LatLng(36.82990371331767, 127.18022724802745),
    LatLng(36.82876674420636, 127.17977900834666),
    LatLng(36.82839453209551, 127.18159404825123),
    LatLng(36.826534838425715, 127.18235186916161),
    LatLng(36.82608035605323, 127.18197528960386),
    LatLng(36.82530941393403, 127.18229852140279),
    LatLng(36.82545220384936, 127.1832011762635),
    LatLng(36.82589369313384, 127.18323585563941),
    LatLng(36.82641869776802, 127.18462142354441),
    LatLng(36.8283930017052, 127.1840544914855),
    LatLng(36.828461000619335, 127.18378563032861),
    LatLng(36.82863829677594, 127.18276039787843),
    LatLng(36.829313469671476, 127.1817195240613),
    LatLng(36.829603672754665, 127.18198363368744),
  ];

  bool isInsidePolygon(LatLng point, List<LatLng> polygon) {
    int intersectCount = 0;

    for (int i = 0; i < polygon.length; i++) {
      LatLng a = polygon[i];
      LatLng b = polygon[(i + 1) % polygon.length];

      if (a.lng == b.lng) continue; // 수직선은 제외

      // a.lng <= b.lng 순으로 정렬
      if (a.lng > b.lng) {
        final temp = a;
        a = b;
        b = temp;
      }

      // 현재 점이 선분의 Y 범위 내에 있는지 체크
      if (point.lng > a.lng && point.lng <= b.lng) {
        final slope = (b.lat - a.lat) / (b.lng - a.lng);
        final intersectLat = slope * (point.lng - a.lng) + a.lat;

        if (point.lat < intersectLat) {
          intersectCount++;
        }
      }
    }

    return (intersectCount % 2 == 1);
  }

  bool isPointInAsanArea() {
    if (!hasLocation) return false;
    return isInsidePolygon(locationData!, asanArea);
  }

  bool isPointInCheonanArea() {
    if (!hasLocation) return false;
    return isInsidePolygon(locationData!, cheonanArea);
  }

  bool isPointInAsanAreaIOSBackground(double lat, double lon) {
    return isInsidePolygon(LatLng(lat, lon), asanArea);
  }

  bool isPointInCheonanAreaIOSBackground(double lat, double lon) {
    return isInsidePolygon(LatLng(lat, lon), cheonanArea);
  }

  void checkIsValidArea() async {
    final PedometerController pedometerController =
        Get.find<PedometerController>();
    final DateTime now = DateTime.now();

    // log("LocationController : checkIsValidArea() : isPointInAsanArea(): ${isPointInAsanArea()}, isPointInCheonanArea(): ${isPointInCheonanArea()}, pedometerController.isInValidArea: ${pedometerController.isInValidArea}");

    if (isLocationPermissionDenied) {
      pedometerController.isInValidArea = false;
      return;
    }

    if (!isPointInAsanArea() && !isPointInCheonanArea()) {
      if (!pedometerController.isInValidArea) return;
      pedometerController.isInValidArea = false;
      BEATLogger.d(
          "LocationController : checkIsValidArea() : User Location Out of Range : ${locationData?.lat}, ${locationData?.lng}");

      // if (now.hour < endHour &&
      //     now.minute < endMinute &&
      //     now.second < endSecond) {
      //   LocalNotificationManager.showValidAreaNotification(
      //     localizationManager.lnOutOfRangeTitle,
      //     localizationManager.lnOutOfRangeBody,
      //   );
      // }

      LocalNotificationManager.showValidAreaNotification(
        localizationManager.lnOutOfRangeTitle,
        localizationManager.lnOutOfRangeBody,
      );
    } else {
      if (pedometerController.isInValidArea) return;
      pedometerController.isInValidArea = true;
      BEATLogger.d(
          "LocationController : checkIsValidArea() : User Location Back in Range : ${locationData?.lat}, ${locationData?.lng}");

      // if (now.hour < endHour &&
      //     now.minute < endMinute &&
      //     now.second < endSecond) {
      //   LocalNotificationManager.showValidAreaNotification(
      //     localizationManager.lnBackInRangeTitle,
      //     localizationManager.lnBackInRangeBody,
      //   );
      // }

      LocalNotificationManager.showValidAreaNotification(
        localizationManager.lnBackInRangeTitle,
        localizationManager.lnBackInRangeBody,
      );
    }
  }

  // iOS 백그라운드 위치 업데이트용
  void checkIsValidAreaIOSBackground(double lat, double lon) async {
    final PedometerController pedometerController =
        Get.find<PedometerController>();
    final DateTime now = DateTime.now();

    // log("LocationController : checkIsValidArea() : isPointInAsanArea(): ${isPointInAsanArea()}, isPointInCheonanArea(): ${isPointInCheonanArea()}, pedometerController.isInValidArea: ${pedometerController.isInValidArea}");

    if (isLocationPermissionDenied) pedometerController.isInValidArea = false;

    if (!isPointInAsanAreaIOSBackground(lat, lon) &&
        !isPointInCheonanAreaIOSBackground(lat, lon)) {
      if (!pedometerController.isInValidArea) return;
      pedometerController.isInValidArea = false;
      BEATLogger.d(
          "LocationController : checkIsValidAreaIOSBackground() : User Location Out of Range : ${locationData?.lat}, ${locationData?.lng}");

      // if (now.hour < endHour &&
      //     now.minute < endMinute &&
      //     now.second < endSecond) {
      //   LocalNotificationManager.showValidAreaNotification(
      //     localizationManager.lnOutOfRangeTitle,
      //     localizationManager.lnOutOfRangeBody,
      //   );
      // }

      LocalNotificationManager.showValidAreaNotification(
        localizationManager.lnOutOfRangeTitle,
        localizationManager.lnOutOfRangeBody,
      );
    } else {
      if (pedometerController.isInValidArea) return;
      pedometerController.isInValidArea = true;
      BEATLogger.d(
          "LocationController : checkIsValidAreaIOSBackground() : User Location Back in Range : ${locationData?.lat}, ${locationData?.lng}");

      // if (now.hour < endHour &&
      //     now.minute < endMinute &&
      //     now.second < endSecond) {
      //   LocalNotificationManager.showValidAreaNotification(
      //     localizationManager.lnBackInRangeTitle,
      //     localizationManager.lnBackInRangeBody,
      //   );
      // }

      LocalNotificationManager.showValidAreaNotification(
        localizationManager.lnBackInRangeTitle,
        localizationManager.lnBackInRangeBody,
      );
    }
  }

  /// iOS 네이티브에서 정확한 시간(매시간 정각)에 호출되는 백그라운드 걸음 수 동기화
  Future<void> _syncWalkDataInBackground() async {
    BEATLogger.d("LocationController : _syncWalkDataInBackground()");
    try {
      final pedometerController = Get.find<PedometerController>();
      if (!pedometerController.isActivityPermissionDenied && 
          !pedometerController.isLocationPermissionDenied) {
        pedometerController.addWalkReport();
        BEATLogger.d("LocationController : 백그라운드 걸음 수 동기화 완료");
      }
    } catch (e) {
      BEATLogger.e("LocationController : 백그라운드 걸음 수 동기화 실패: $e");
    }
  }

  /// iOS 네이티브에서 정확한 시간(매시간 정각)에 호출되는 백그라운드 랭킹 집계
  Future<void> _syncRankingInBackground() async {
    BEATLogger.d("LocationController : _syncRankingInBackground()");
    try {
      final pedometerController = Get.find<PedometerController>();
      if (!pedometerController.isActivityPermissionDenied && 
          !pedometerController.isLocationPermissionDenied) {
        // 실제 걸음 수 전송 로직 실행
        pedometerController.addWalkReport();
        BEATLogger.d("LocationController : 백그라운드 랭킹 집계 완료 - 걸음 수 전송됨");
      } else {
        BEATLogger.d("LocationController : 권한이 없어서 랭킹 집계 건너뜀");
      }
    } catch (e) {
      BEATLogger.e("LocationController : 백그라운드 랭킹 집계 실패: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;

    _eventDurationTimer?.cancel();
    _eventDurationTimer = null;

    _midnightTimer?.cancel();
    _midnightTimer = null;

    super.dispose();
  }
}
