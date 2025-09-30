import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:beat_flutter/controller/location/location_controller.dart';
import 'package:beat_flutter/controller/pedometer/pedometer_controller.dart';
import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/background_service/background_service_entry.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../managers/logger/beat_logger.dart';

const String notificationChannelId = "activity_service_channel";
const String notificationChannelTitle = "BEAT Activity Service";
const String notificationChannelDescription =
    "This channel is used for activity service notifications.";
const foregroundServiceNotificationId = 888;

class ActivityServiceController extends GetxController {
  /// iOS 네이티브와 통신하기 위한 MethodChannel
  /// 모든 백그라운드 작업(걸음 수 동기화, 랭킹 집계, 자정 초기화)이 이 채널을 통해 이루어짐

  /// [locationChannel] 핸들러
  ///
  ///   "startBackgroundTasks"    4시간 단위 걸음 수 동기화 시작, 랭킹 집계 시작, 자정 초기화 시작,
  ///                           위치 추적 시작
  ///
  ///   "stopBackgroundTasks"     위치 추적 중지,
  ///                           4시간 단위 걸음 수 동기화 중지, 랭킹 집계 중지, 자정 초기화 중지
  ///
  ///   "updateHolidayStatus"     isHoliday가 true이면 위치 추적 중지,
  ///                           isHoliday가 false이면 위치 추적 재시작
  ///
  static const _locationChannel = MethodChannel("com.beat.walkreport/location");

  /// [pedometerChannel] 핸들러
  ///
  /// "isMotionPermissionGranted"   활동 권한이 부여되었는지 확인.
  ///                               iOS는 안드로이드와 달리 permission_handler 패키지를 사용해 활동 권한을 정확히 받아올 수 없음.
  ///                               메소드 채널을 통해 iOS 네이티브에서 권한 부여 여부를 정확히 확인하고 플러터 UI isolate에 전달.
  ///
  /// "startPedometer"              걸음 수 측정 시작. 걸음 수 이벤트 발생 시마다 메소드 채널 핸들러를 통해 플러터 UI isolate에 전달.
  ///
  /// "stopPedometer"               걸음 수 측정 중지
  ///
  /// "startActivityUpdates"        보행 상태 추적 시작
  ///
  /// "stopActivityUpdates"         보행 상태 추적 중지
  ///
  static const _pedometerChannel =
      MethodChannel("com.beat.walkreport/pedometer");

  final LocalizationManager localizationManager = LocalizationManager();

  final List<StreamSubscription> _fbsSubscriptions = [];

  late final PedometerController pedometerController;
  late final LocationController locationController;

  String authorization = "";

  int sendToTime = 0;
  bool isHoliday = true;

  ActivityServiceController() {
    pedometerController = Get.find<PedometerController>();
    locationController = Get.find<LocationController>();
  }

  /// 단일 백그라운드 서비스 초기화 (부팅 자동 시작 비활성화)
  Future<void> initializeService() async {
    try {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        notificationChannelId, // id
        notificationChannelTitle,
        description: notificationChannelDescription,
        importance: Importance.low, // importance must be at low or higher level
      );

      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      final service = FlutterBackgroundService();
      await service.configure(
        iosConfiguration: IosConfiguration(
          autoStart: false,
          onForeground: startServiceIOS,
          onBackground: startBackgroundServiceIOS,
        ),
        androidConfiguration: AndroidConfiguration(
            onStart: startServiceAndroid,
            autoStart: false,
            isForegroundMode: true,
            autoStartOnBoot: false,
            notificationChannelId: notificationChannelId,
            initialNotificationTitle:
                localizationManager.generalInitialNotificationTitle,
            initialNotificationContent:
                localizationManager.generalInitialNotificationContent,
            foregroundServiceNotificationId: foregroundServiceNotificationId,
            foregroundServiceTypes: [
              AndroidForegroundType.location,
              AndroidForegroundType.dataSync
            ]),
      );
    } catch (e) {
      print('Failed to initialize background service: $e');
      // 서비스 초기화 실패 시에도 앱이 계속 실행되도록 함
    }
  }

  Future<void> startService() async {
    try {
      if (Platform.isIOS) {
        isHoliday = await _getIsHoliday();
        // isHoliday = false;
        pedometerController.isHoliday = isHoliday;
        pedometerController.getWalkHitory();

        _setIOSLocationChannelHandler();

        await _locationChannel.invokeMethod("stopBackgroundTasks");
        _locationChannel.invokeMethod("startBackgroundTasks",
            {"isHoliday": isHoliday, "sendToTime": sendToTime});
        // _locationChannel.invokeMethod("startBackgroundTasks",
        //     {"isHoliday": false, "sendToTime": sendToTime});

        _setIOSPedometerChannelHandler();

        await _pedometerChannel.invokeMethod("stopActivityUpdates");
        _pedometerChannel.invokeMethod("startActivityUpdates");

        await _pedometerChannel.invokeMethod("stopPedometer");
        _pedometerChannel.invokeMethod("startPedometer");

        return;
      } else {
        _setAndroidBackgroundServiceHandler();

        final service = FlutterBackgroundService();

        if (!await service.isRunning()) {
          BEATLogger.d("service.isRunning");
          await service.startService();
        }

        service.invoke("startBackgroundTasks",
            {"authorization": authorization, "sendToTime": sendToTime});

        return;
      }
    } catch (e) {
      BEATLogger.d('Failed to start service: $e');
      // 서비스 시작 실패 시에도 앱이 계속 실행되도록 함
    }
  }

  void _setAndroidBackgroundServiceHandler() {
    if (Platform.isAndroid) {
      final service = FlutterBackgroundService();

      if (_fbsSubscriptions.isNotEmpty) return;

      _fbsSubscriptions.add(service.on("updateUISteps").listen((data) {
        if (data == null) return;
        pedometerController.todayWalkCount = data["todayWalkCount"] ?? 0;
        pedometerController.weeklyWalkCount = data["weeklyWalkCount"] ?? 0;
        pedometerController.monthlyWalkCount = data["monthlyWalkCount"] ?? 0;
        pedometerController.totalWalkCount = data["totalWalkCount"] ?? 0;
      }));

      _fbsSubscriptions.add(service.on("updateIsInValidArea").listen((data) {
        if (data == null) return;
        pedometerController.isInValidArea = data["isInValidArea"] ?? false;
      }));

      _fbsSubscriptions.add(service.on("midnightReset").listen((data) {
        if (data == null) return;
        pedometerController.isHoliday = data["isHoliday"] ?? true;
        pedometerController.todayWalkCount = data["todayWalkCount"] ?? 0;
        pedometerController.weeklyWalkCount = data["weeklyWalkCount"] ?? 0;
        pedometerController.monthlyWalkCount = data["monthlyWalkCount"] ?? 0;
        pedometerController.totalWalkCount = data["totalWalkCount"] ?? 0;
      }));

      _fbsSubscriptions.add(service.on('bg_started').listen((data) {
        if (data == null) return;
        log("ActivityServiceController: _setAndroidBackgroundServiceHandler() : bg_started received: data: $data");
        pedometerController.isHoliday = data["isHoliday"] ?? true;
        pedometerController.isInValidArea = data["isInValidArea"] ?? false;
        pedometerController.todayWalkCount = data["todayWalkCount"] ?? 0;
        pedometerController.weeklyWalkCount = data["weeklyWalkCount"] ?? 0;
        pedometerController.monthlyWalkCount = data["monthlyWalkCount"] ?? 0;
        pedometerController.totalWalkCount = data["totalWalkCount"] ?? 0;
      }));

      _fbsSubscriptions.add(service.on('bg_ready').listen((data) {
        log("ActivityServiceController : _setAndroidBackgroundServiceHandler() : bg_ready received");
        service.invoke("startBackgroundTasks",
            {"authorization": authorization, "sendToTime": sendToTime});
      }));
    }
  }

  void _setIOSLocationChannelHandler() {
    _locationChannel.setMethodCallHandler(
      (call) async {
        switch (call.method) {
          case "backgroundLocationUpdate":
            final args = call.arguments as Map?;
            if (args == null) return;
            final double lat = (args["latitude"] as num).toDouble();
            final double lon = (args["longitude"] as num).toDouble();
            locationController.checkIsValidAreaBackground(lat, lon);
            break;

          case "midnightReset":
            isHoliday = await _getIsHoliday();
            _resetAtMidnight();
            break;

          case "syncWalkDataInBackground":
            await locationController.syncWalkDataInBackground();
            break;

          case "syncRankingInBackground":
            await locationController.syncRankingInBackground();
            break;
        }
      },
    );
  }

  void _setIOSPedometerChannelHandler() {
    _pedometerChannel.setMethodCallHandler(
      (call) async {
        switch (call.method) {
          case "updateStepsFromNative":
            final steps = call.arguments["steps"] as int;
            pedometerController.onStepCountFromNative(steps);
            break;
          case "updatePedestrianStatus":
            final status = call.arguments["status"] as String;
            pedometerController.onPedestrianStatusChangedFromNative(status);
            break;
        }
      },
    );
  }

  Future<void> stopService() async {
    try {
      if (Platform.isIOS) {
        _locationChannel.invokeMethod("stopBackgroundTasks");
        _locationChannel.setMethodCallHandler(null);

        // await PrefsManager().setSteps(
        //     todayWalkCount, weeklyWalkCount, monthlyWalkCount, totalWalkCount);
        //
        // if (stepsAfterLastBoot != null) {
        //   await PrefsManager().setStepsAfterLastboot(stepsAfterLastBoot!);
        // }

        _pedometerChannel.invokeMethod("stopPedometer");
        _pedometerChannel.invokeMethod("stopActivityUpdates");
        _pedometerChannel.setMethodCallHandler(null);
        // Get.find<LocationController>().stopServiceIOS();
        return;
      } else {
        final service = FlutterBackgroundService();

        for (final s in _fbsSubscriptions) {
          s.cancel();
        }
        _fbsSubscriptions.clear();

        if (await service.isRunning()) {
          service.invoke('stopService');
        }
        return;
      }
    } catch (e) {
      print('Failed to stop service: $e');
      // 서비스 중지 실패 시에도 앱이 계속 실행되도록 함
    }
  }

  void _resetAtMidnight() async {
    isHoliday = await _getIsHoliday();

    pedometerController.isHoliday = isHoliday;
    pedometerController.resetAtMidnight();

    if (Platform.isIOS) {
      await _locationChannel
          .invokeMethod("updateHolidayStatus", {"isHoliday": isHoliday});
    }
  }

  /// API 요청을 통해 오늘이 공휴일인지를 확인.
  /// 서버는 이번 달의 공휴일 리스트를 응답하는데, 이 리스트에 오늘 날짜가 포함되었는지, 오늘이 토요일 혹은 일요일인지를 확인한다.
  /// 상태코드가 200이 아니거나 오류 발생 시에는 false를 반환한다.
  Future<bool> _getIsHoliday() async {
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
            now.weekday == DateTime.saturday ||
            now.weekday == DateTime.sunday;
      }
      return false;
    } catch (e) {
      return false;
    }
    // return false;
  }

  /// 베타 테스트용 공휴일 여부 판별 함수.
  /// 오늘이 토요일 혹은 일요일인지 여부만을 확인한다.
  Future<bool> _getIsHolidayTest() async {
    final DateTime now = DateTime.now();

    return now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
  }

  /// 라우팅 인자 위임용 API
  void setAuthorization(String authorization) {
    this.authorization = authorization;
    pedometerController.setAuthorization(authorization);
  }

  void setSendToTime(int value) {
    sendToTime = value;
  }

  Future<void> getWalkHistory() async {
    await pedometerController.getWalkHitory();
  }

  void addWalkReport() {
    if (Platform.isIOS) {
      pedometerController.addWalkReport();
    } else {
      FlutterBackgroundService().invoke("addWalkReport");
    }
  }
}
