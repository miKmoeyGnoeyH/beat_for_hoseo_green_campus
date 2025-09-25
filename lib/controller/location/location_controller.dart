import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:beat_flutter/controller/pedometer/pedometer_controller.dart';
import 'package:beat_flutter/managers/background_service/background_service_entry.dart';
import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/logger/beat_logger.dart';
import 'package:beat_flutter/managers/notification/local_notification.dart';
import 'package:beat_flutter/managers/permission/permission_manager.dart';
import 'package:beat_flutter/managers/prefs/prefs_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
  /// iOS 네이티브와 통신하기 위한 MethodChannel
  /// 모든 백그라운드 작업(걸음 수 동기화, 랭킹 집계, 자정 초기화)이 이 채널을 통해 이루어짐
  static const _channel = MethodChannel("com.beat.walkreport/location");

  // 위치
  final Rx<LatLng?> _locationData = Rx<LatLng?>(null);

  LatLng? get locationData => _locationData.value;

  set locationData(LatLng? value) => _locationData.value = value;

  bool get hasLocation => locationData != null;

  // 언어
  final LocalizationManager localizationManager = LocalizationManager();

  /// 타이머들
  ///
  /// [_updateLocationTimer] : 위치 갱신 및 유효 범위 체크용 타이머
  /// [_eventDurationTimer] : 이벤트 진행 시간 측정용 타이머(현재 사용 안됨)
  /// [_midnightTimer] : 매일 자정에 걸음 수 초기화
  ///
  /// 위 세 가지 타이머 중 [_midnightTimer]는 중지되지 않아야 한다.
  ///
  /// 로그인한 사용자가 없을 때, 즉 앱이 사용중이지 않을 때는 위치정보를 수집할 필요가 없으므로
  /// [_updateLocationTimer]는 중지된다.
  ///
  /// [_eventDurationTimer]는 현재 사용되지 않지만, 매 초 현재 시각이 이벤트 진행 시간 내인지를 확인하고,
  /// 만약 이벤트 시간이 지났거나 공휴일이라면 중지된다.
  ///
  /// 반면 [_midnightTimer]는 로그인된 사용자가 있다면 매일 자정 [PedometerController]의 [resetAtMidnight]를 호출해
  /// 걸음 수를 초기화하고, 날짜가 변경되었으므로 공휴일 여부를 확인해 만약 공휴일이 아니라면 [_updateLocationTimer]를 시작하며,
  /// 기획에 따라 [_eventDurationTimer]를 시작해야 할 수도 있기 때문에 [_midnightTimer]는 중지되어서는 안 된다.
  ///
  /// 지속적으로 사용자 위치를 갱신해 유효 범위 내에 있는지를 확인하기 위한 타이머
  Timer? _updateLocationTimer;

  /// [_eventDurationTimer] : 이벤트 진행 시간 측정용 타이머(현재 사용 안됨)
  final int endHour = 18;
  final int endMinute = 0;
  final int endSecond = 0;
  Timer? _eventDurationTimer;

  /// [_midnightTimer] : 매일 자정에 걸음 수 초기화
  Timer? _midnightTimer;

  LocationController();

  /// 백그라운드 서비스 초기화
  Future<void> initializeService() async {
    final service = FlutterBackgroundService();
    await service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: startLocationTimerForeground,
        onBackground: startLocationTimerBackgroundIOS,
      ),
      androidConfiguration: AndroidConfiguration(
        autoStart: false,
        onStart: startLocationTimerForeground,
        isForegroundMode: false,
        autoStartOnBoot: false,
      ),
    );
  }

  /// API 요청을 통해 오늘이 공휴일인지를 확인.
  /// 서버는 이번 달의 공휴일 리스트를 응답하는데, 이 리스트에 오늘 날짜가 포함되었는지, 오늘이 토요일 혹은 일요일인지를 확인한다.
  /// 상태코드가 200이 아니거나 오류 발생 시에는 false를 반환한다.
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
        return (responseBody.any((e) => e["date"] == nowFormatted)) ||
            now.day == DateTime.saturday ||
            now.day == DateTime.sunday;
      }
      return false;
    } catch (e) {
      BEATLogger.d("LocationController : getIsHoliday error : ${e.toString()}");
      return false;
    }
  }

  /// 베타 테스트용 공휴일 여부 판별 함수.
  /// 오늘이 토요일 혹은 일요일인지 여부만을 확인한다.
  Future<bool> getIsHolidayTest() async {
    final DateTime now = DateTime.now();

    BEATLogger.d(
        "LocationController : getIsHolidayTest : now: $now, now.day: ${now.day}, now.weekday: ${now.weekday}");

    return now.weekday == DateTime.saturday || now.day == DateTime.sunday;
  }

  void stopUpdateLocationTimer() {
    _updateLocationTimer?.cancel();
    _updateLocationTimer = null;
  }

  void startUpdateLocationTimer() {
    stopUpdateLocationTimer();

    _updateLocationTimer = Timer.periodic(
      const Duration(seconds: 5),
      (t) async {
        await PermissionManager
            .ensureLocationAndActivityPermissionInitialized();
        if (!PermissionManager.isLocationPermissionGrantedStatic!) return;
        await fetchLocation();
        checkIsValidArea();
      },
    );
  }

  void stopMidnightTimer() {
    _midnightTimer?.cancel();
    _midnightTimer = null;
  }

  void startMidnightTimer() {
    stopMidnightTimer();

    _midnightTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        final now = DateTime.now();
        if (now.hour == 0 && now.minute == 0 && now.second == 0) {
          // if (now.minute % 5 == 0 && now.second == 0) {
          BEATLogger.d("resetAtMidnight()");
          _resetAtMidnight();
        }
      },
    );
  }

  void startForegroundService() async {
    BEATLogger.d("LocationController : startForegroundService()");

    await PermissionManager.updateLocationAndActivityPemission();

    await fetchLocation();
    checkIsValidArea();

    final bool isHoliday = await getIsHoliday();
    final pedometerController = Get.find<PedometerController>();

    pedometerController.isHoliday = isHoliday;

    stopUpdateLocationTimer();
    stopMidnightTimer();

    if (!isHoliday) {
      startUpdateLocationTimer();
    }
    startMidnightTimer();
  }

  Future<void> stopForegroundService() async {
    BEATLogger.d("LocationController : stopForegroundService()");

    // _channel.setMethodCallHandler(null);

    stopUpdateLocationTimer();
    stopMidnightTimer();
  }

  void startBackgroundService() async {
    BEATLogger.d("LocationController : startBackgroundService()");

    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    await PermissionManager.updateLocationAndActivityPemission();
    await EasyLocalization.ensureInitialized();

    await fetchLocation();
    checkIsValidArea();

    if (Platform.isIOS) {
      final bool isHoliday = await getIsHoliday();
      // final bool isHoliday = await getIsHolidayTest();
      final int sendToTime = Get.find<PedometerController>().sendToTime;

      setMethodCallHandler();

      await _channel.invokeMethod("stopBackgroundTasks");
      _channel.invokeMethod("startBackgroundTasks",
          {"isHoliday": isHoliday, "sendToTime": sendToTime});
    }

    FlutterBackgroundService().startService();
  }

  Future<void> stopBackgroundService() async {
    BEATLogger.d("LocationController : stopBackgroundService()");
    FlutterBackgroundService().invoke("stopService");

    if (Platform.isIOS) {
      _channel.invokeMethod("stopBackgroundTasks");
      _channel.setMethodCallHandler(null);
    }

    stopUpdateLocationTimer();
    stopMidnightTimer();
  }

  /// 자정 초기화
  void _resetAtMidnight() async {
    BEATLogger.d("LocationController : _resetAtMidnight()");

    final pedometerController = Get.find<PedometerController>();
    final bool isHoliday = await getIsHoliday();

    pedometerController.isHoliday = isHoliday;
    pedometerController.resetAtMidnight(DateTime.now());

    BEATLogger.d("LocationController : 걸음 수 초기화 완료");

    if (Platform.isIOS) {
      await _channel
          .invokeMethod("updateHolidayStatus", {"isHoliday": isHoliday});
      BEATLogger.d("LocationController : iOS 네이티브에 공휴일 상태 업데이트 완료");
    }

    if (isHoliday) {
      stopUpdateLocationTimer();
      BEATLogger.d("LocationController : 공휴일로 인해 이벤트 타이머 중단");
      return;
    }

    startUpdateLocationTimer();
    BEATLogger.d("LocationController : 자정 초기화 완료 - 위치 추적 재시작");
    // _startEventDurationTimer();
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
              // Get.find<PedometerController>().isEventDuration.value = false;
              // _stopEventTimers();
              break;

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

  Future<void> fetchLocation() async {
    await PermissionManager.updateLocationAndActivityPemission();
    if (!PermissionManager.isLocationPermissionGrantedStatic!) return;

    try {
      final location = Location();
      final newLocationData = await location.getLocation();

      if (newLocationData.latitude == null || newLocationData.longitude == null) {
        return;
      }

      locationData = LatLng(
        newLocationData.latitude!,
        newLocationData.longitude!,
      );
    } catch (e) {
      BEATLogger.e("LocationController : fetchLocation error: $e");
      // 권한 변경 직후 등 예외 상황에서 크래시 방지
      return;
    }
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

      if (a.lng == b.lng) continue;

      if (a.lng > b.lng) {
        final temp = a;
        a = b;
        b = temp;
      }

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

    if (PermissionManager.isLocationPermissionGrantedStatic == null ||
        (PermissionManager.isLocationPermissionGrantedStatic == null &&
            !PermissionManager.isLocationPermissionGrantedStatic!)) {
      pedometerController.isInValidArea = false;
      return;
    }

    if (!isPointInAsanArea() && !isPointInCheonanArea()) {
      if (!pedometerController.isInValidArea) return;
      pedometerController.isInValidArea = false;

      BEATLogger.d(
          "LocationController : checkIsValidArea() : User Location Out of Range : ${locationData?.lat}, ${locationData?.lng}");

      LocalNotificationManager.showValidAreaNotification(
        localizationManager.lnOutOfRangeTitle,
        localizationManager.lnOutOfRangeBody,
      );
    } else {
      if (pedometerController.isInValidArea) return;
      pedometerController.isInValidArea = true;

      BEATLogger.d(
          "LocationController : checkIsValidArea() : User Location Back in Range : ${locationData?.lat}, ${locationData?.lng}");

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

    if (PermissionManager.isLocationPermissionGrantedStatic == null ||
        (PermissionManager.isLocationPermissionGrantedStatic == null &&
            !PermissionManager.isLocationPermissionGrantedStatic!)) {
      pedometerController.isInValidArea = false;
      return;
    }

    if (!isPointInAsanAreaIOSBackground(lat, lon) &&
        !isPointInCheonanAreaIOSBackground(lat, lon)) {
      if (!pedometerController.isInValidArea) return;
      pedometerController.isInValidArea = false;

      BEATLogger.d(
          "LocationController : checkIsValidAreaIOSBackground() : User Location Out of Range : ${locationData?.lat}, ${locationData?.lng}");

      LocalNotificationManager.showValidAreaNotification(
        localizationManager.lnOutOfRangeTitle,
        localizationManager.lnOutOfRangeBody,
      );
    } else {
      if (pedometerController.isInValidArea) return;
      pedometerController.isInValidArea = true;

      BEATLogger.d(
          "LocationController : checkIsValidAreaIOSBackground() : User Location Back in Range : ${locationData?.lat}, ${locationData?.lng}");

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
      await PermissionManager.updateLocationAndActivityPemission();
      if (PermissionManager.isActivityPermissionGrantedStatic! &&
          PermissionManager.isLocationPermissionGrantedStatic!) {
        final pedometerController = Get.find<PedometerController>();
        pedometerController.addWalkReport();
        BEATLogger.d("LocationController : 백그라운드 걸음 수 동기화 완료");
      } else {
        BEATLogger.d("LocationController : 권한이 없어 걸음 수 동기화 건너뜀");
      }
    } catch (e) {
      BEATLogger.e("LocationController : 백그라운드 걸음 수 동기화 실패: $e");
    }
  }

  /// iOS 네이티브에서 정확한 시간(매시간 정각)에 호출되는 백그라운드 랭킹 집계
  Future<void> _syncRankingInBackground() async {
    BEATLogger.d("LocationController : _syncRankingInBackground()");
    try {
      await PermissionManager.updateLocationAndActivityPemission();
      if (PermissionManager.isActivityPermissionGrantedStatic! &&
          PermissionManager.isLocationPermissionGrantedStatic!) {
        final pedometerController = Get.find<PedometerController>();
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
    _updateLocationTimer?.cancel();
    _updateLocationTimer = null;

    _eventDurationTimer?.cancel();
    _eventDurationTimer = null;

    _midnightTimer?.cancel();
    _midnightTimer = null;

    super.dispose();
  }
}
