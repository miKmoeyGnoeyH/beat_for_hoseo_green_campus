import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:beat_flutter/managers/permission/permission_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';

// import 'package:location/location.dart';
import 'package:pedometer/pedometer.dart';

// /// 포어그라운드에서는 안드로이드와 iOS 동작이 동일함
// @pragma('vm:entry-point')
// void startPedometerTimerForeground(ServiceInstance service) {
//   // await DotEnvManager().ensureInitialized();
//   // WidgetsFlutterBinding.ensureInitialized();
//   // DartPluginRegistrant.ensureInitialized();
//   // await EasyLocalization.ensureInitialized();
//
//   return;
// }

// /// 백그라운드 서비스 타이머 시작
// /// 안드로이드는 포어그라운드와 동일한 메소드를 사용하므로
// /// iOS에서 메소드 채널을 설정
// @pragma('vm:entry-point')
// Future<bool> startPedometerTimerBackgroundIOS(ServiceInstance service) async {
//   await DotEnvManager().ensureInitialized();
//   WidgetsFlutterBinding.ensureInitialized();
//   // DartPluginRegistrant.ensureInitialized();
//   await EasyLocalization.ensureInitialized();
//   await BEATLogger.ensureInitialized();
//
//   await PermissionManager.updateLocationAndActivityPemission();
//
//   return true;
// }
//
// @pragma('vm:entry-point')
// void startLocationTimerForeground(ServiceInstance service) async {
//   return;
// }

/// 통합 서비스용 진입점 (ActivityServiceController)
// @pragma('vm:entry-point')
// void startActivityServiceForeground(ServiceInstance service) async {
//   await DotEnvManager().ensureInitialized();
//   WidgetsFlutterBinding.ensureInitialized();
//   DartPluginRegistrant.ensureInitialized();
//   await EasyLocalization.ensureInitialized();
//   await BEATLogger.ensureInitialized();
//
//   await PermissionManager.updateLocationAndActivityPemission();
//
//   // 알림 구성 (안드로이드 포어그라운드 서비스용)
//   final LocalizationManager localizationManager = LocalizationManager();
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   if (service is AndroidServiceInstance) {
//     // 주기적으로 알림 고정 업데이트
//     Timer.periodic(const Duration(minutes: 15), (timer) async {
//       if (await service.isForegroundService()) {
//         flutterLocalNotificationsPlugin.show(
//           foregroundServiceNotificationId,
//           localizationManager.generalInitialNotificationTitle,
//           localizationManager.generalInitialNotificationContent,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               localizationManager.generalInitialNotificationTitle,
//               localizationManager.generalInitialNotificationContent,
//               icon: 'ic_bg_service_small',
//               ongoing: true,
//             ),
//           ),
//         );
//       }
//     });
//   }
//
//   // ===== Android 백그라운드 작업: pedometer + 위치 + 동기화 타이머 =====
//   // StepCount 스트림 -> UI isolate로 디바이스 누적 걸음 수 전달
//   StreamSubscription<StepCount>? stepSubscription;
//   StreamSubscription<PedestrianStatus>? statusSubscription;
//   Timer? locationTimer;
//   Timer? midnightTimer;
//   Timer? hourlySyncTimer;
//   Timer? rankSyncTimer;
//
//   int sendToTime = 0; // UI에서 전달받아 갱신됨
//
//   final service = FlutterBackgroundService();
//
//   void cancelAll() {
//     stepSubscription?.cancel();
//     statusSubscription?.cancel();
//     locationTimer?.cancel();
//     midnightTimer?.cancel();
//     hourlySyncTimer?.cancel();
//     rankSyncTimer?.cancel();
//     stepSubscription = null;
//     statusSubscription = null;
//     locationTimer = null;
//     midnightTimer = null;
//     hourlySyncTimer = null;
//     rankSyncTimer = null;
//   }
//
//   // stop 요청 처리
//   service.on('stopService').listen((event) async {
//     BEATLogger.d('BackgroundService: stopService received');
//     cancelAll();
//     if (service is AndroidServiceInstance) {
//       await service.stopSelf();
//     }
//   });
//
//   // UI에서 동기화 second 설정 전달
//   service.on('setSendToTime').listen((data) {
//     if (data == null) return;
//     final int? value = data['value'];
//     if (value != null) {
//       sendToTime = value;
//       BEATLogger.d('BackgroundService: setSendToTime -> $sendToTime');
//     }
//   });
//
//   // 권한 점검 후 스트림/타이머 시작
//   await PermissionManager.ensureLocationAndActivityPermissionInitialized();
//
//   // Pedometer 스트림
//   try {
//     final stepStream = Pedometer.stepCountStream;
//     stepSubscription = stepStream.listen((event) {
//       service.invoke('onStepCountFromNative', {
//         'stepsFromNative': event.steps,
//       });
//     });
//
//     final statusStream = Pedometer.pedestrianStatusStream;
//     statusSubscription = statusStream.listen((event) {
//       service.invoke('onPedestrianStatusFromNative', {
//         'status': event.status,
//       });
//     });
//   } catch (e) {
//     BEATLogger.e('BackgroundService: pedometer stream error: $e');
//   }
//
//   // 위치 주기 수집 -> UI에서 폴리곤 판정 수행
//   final location = Location();
//   locationTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
//     try {
//       await PermissionManager.ensureLocationAndActivityPermissionInitialized();
//       if (!(PermissionManager.isLocationPermissionGrantedStatic ?? false)) {
//         return;
//       }
//       final data = await location.getLocation();
//       if (data.latitude == null || data.longitude == null) return;
//       service.invoke('backgroundLocationUpdate', {
//         'latitude': data.latitude,
//         'longitude': data.longitude,
//       });
//     } catch (e) {
//       // ignore runtime hiccups
//     }
//   });
//
//   // 자정(테스트: 5분마다 0초)에 리셋 트리거
//   midnightTimer = Timer.periodic(const Duration(seconds: 1), (_) {
//     final now = DateTime.now();
//     if (now.minute % 5 == 0 && now.second == 0) {
//       service.invoke('midnightReset');
//     }
//   });
//
//   // 1시간마다 동기화 트리거
//   hourlySyncTimer = Timer.periodic(const Duration(hours: 1), (_) async {
//     await PermissionManager.ensureLocationAndActivityPermissionInitialized();
//     if ((PermissionManager.isActivityPermissionGrantedStatic ?? false) &&
//         (PermissionManager.isLocationPermissionGrantedStatic ?? false)) {
//       service.invoke('syncWalkDataInBackground');
//     }
//   });
//
//   // 3분 주기 특정 초에 랭킹 동기화 트리거
//   rankSyncTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
//     await PermissionManager.ensureLocationAndActivityPermissionInitialized();
//     if ((PermissionManager.isActivityPermissionGrantedStatic ?? false) &&
//         (PermissionManager.isLocationPermissionGrantedStatic ?? false)) {
//       final now = DateTime.now();
//       if (now.minute % 3 == 0 && now.second == sendToTime) {
//         service.invoke('syncRankingInBackground');
//       }
//     }
//   });
// }

// @pragma('vm:entry-point')
// Future<bool> startActivityServiceBackgroundIOS(ServiceInstance service) async {
//   await DotEnvManager().ensureInitialized();
//   WidgetsFlutterBinding.ensureInitialized();
//   DartPluginRegistrant.ensureInitialized();
//   await EasyLocalization.ensureInitialized();
//   await BEATLogger.ensureInitialized();
//
//   await PermissionManager.updateLocationAndActivityPemission();
//
//   final LocalizationManager localizationManager = LocalizationManager();
//   final service = FlutterBackgroundService();
//
//   service.invoke("updateNotification", {
//     "title": localizationManager.generalInitialNotificationTitle,
//     "content": localizationManager.generalInitialNotificationContent,
//   });
//
//   return true;
// }
//
// @pragma('vm:entry-point')
// Future<bool> startLocationTimerBackgroundIOS(ServiceInstance service) async {
//   await DotEnvManager().ensureInitialized();
//   WidgetsFlutterBinding.ensureInitialized();
//   DartPluginRegistrant.ensureInitialized();
//   await EasyLocalization.ensureInitialized();
//   await BEATLogger.ensureInitialized();
//
//   await PermissionManager.updateLocationAndActivityPemission();
//
//   return true;
// }

@pragma('vm:entry-point')
Future<void> startServiceAndroid(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  // DartPluginRegistrant.ensureInitialized();

  await PermissionManager.updateLocationAndActivityPemission();

  /// 초기 알림 설정
  if (service is AndroidServiceInstance) {
    await service.setForegroundNotificationInfo(
      title: 'BEAT',
      content: 'BEAT가 걸음 수를 측정중입니다.',
    );
    await service.setAsForegroundService();
  }

  /// 15분 간격으로 알림 업데이트
  if (service is AndroidServiceInstance) {
    Timer.periodic(const Duration(minutes: 15), (timer) async {
      if (await service.isForegroundService()) {
        // await service.setAsForegroundService();
        await service.setForegroundNotificationInfo(
          title: 'BEAT',
          content: 'BEAT가 걸음 수를 측정중입니다.',
        );
      }
    });
  }

  // ===== Android 백그라운드 작업: pedometer + 위치 + 동기화 타이머 =====
  // StepCount 스트림 -> UI isolate로 디바이스 누적 걸음 수 전달
  /// 걸음 수 이벤트 구독 스트림
  StreamSubscription<StepCount>? stepSubscription;

  /// 보행 상태 이벤트 구독 스트림
  StreamSubscription<PedestrianStatus>? statusSubscription;

  /// 위치 정보 스트림
  StreamSubscription<Position>? positionSubscription;

  StreamSubscription<ServiceStatus>? serviceStatusSub;

  /// 위치 갱신 타이머
  /// 공유일에는 위치 추적이 중지됨
  // Timer? locationTimer;

  /// 자정 초기화 타이머
  /// 절대로 이 타이머는 멈추면 안됨
  /// (테스트용으로 5분마다 0초에 초기화 신호 전송)
  Timer? midnightTimer;

  /// 1시간 단위 걸음 수 동기화 타이머
  Timer? hourlySyncTimer;

  /// 매 시간 특정 초에 랭킹 집계를 위해 서버로 걸음 수를 전송함
  Timer? rankSyncTimer;

  Timer? permissionCheckTimer;

  bool? hasLocationPermission;
  bool? hasActivityPermission;

  /// 위치 정보 저장 변수
  // final location = Location();

  /// 랭킹 집계를 위해 서버로 걸음 수를 전송할 때, 몇 초에 전송할 것인지를 저장하는 변수
  /// 실제로 background isolate에서는 데이터를 전송하지 않고, [FlutterBackgroundService]의
  /// 채널 핸들러를 통해 UI isolate로 신호를 보내고, 이를 UI isolate에서 처리함.
  /// 이 값은 로그인 성공 -> 라우팅 관리 클래스에서 [ActivityServiceController.setAuthorization] 호출 ->
  /// [PedometerController]의 authorization 설정 -> [ActivityServiceController.setSendToTime] 호출
  /// -> [ActivityController]의 sentToTime 설정 -> [ScreenHolder.initState] ->
  /// [ScreenHolder.showDialogIfPermissionDenied] ->
  /// [Get.find<ActivityServiceController>().startService();] ->
  /// [ActivityController]Android 분기에서
  /// [service.invoke("setSendToTime", {"value": sendToTime});]으로 전달
  ///
  int sendToTime = 0;

  /// 공휴일 여부
  /// 실제로 background isolate에서는 데이터를 전송하지 않고, [FlutterBackgroundService]의
  /// 채널 핸들러를 통해 UI isolate로 신호를 보내고, 이를 UI isolate에서 처리함.
  /// 이 값은 로그인 성공 -> 라우팅 관리 클래스에서 [ActivityServiceController.setAuthorization] 호출 ->
  /// [PedometerController]의 authorization 설정 -> [ActivityServiceController.setSendToTime] 호출
  /// -> [ActivityController]의 sentToTime 설정 -> [ActivityController]Android 분기에서
  /// -> [ActivityController]의 sentToTime 설정 -> [ScreenHolder.initState] ->
  /// [ScreenHolder.showDialogIfPermissionDenied] ->
  /// [Get.find<ActivityServiceController>().startService();] ->
  /// [ActivityController]Android 분기에서
  /// [service.invoke("updateHolidayStatus", {"isHoliday": isHoliday});]로 전달
  ///
  bool isHoliday = true;

  void cancelAll() {
    stepSubscription?.cancel();
    statusSubscription?.cancel();
    positionSubscription?.cancel();
    midnightTimer?.cancel();
    hourlySyncTimer?.cancel();
    rankSyncTimer?.cancel();
    permissionCheckTimer?.cancel();
    serviceStatusSub?.cancel();

    stepSubscription = null;
    statusSubscription = null;
    positionSubscription = null;
    midnightTimer = null;
    hourlySyncTimer = null;
    rankSyncTimer = null;
    permissionCheckTimer = null;
    serviceStatusSub = null;
  }

  void setPositionStream() {
    positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.best),
    ).listen(
      (position) {
        service.invoke('backgroundLocationUpdate', {
          'latitude': position.latitude,
          'longitude': position.longitude,
        });
      },
      onDone: () {
        positionSubscription = null;
      },
      onError: (e) async {
        log('BackgroundService: location stream error: $e');
        await positionSubscription?.cancel();
        positionSubscription = null;
      },
      cancelOnError: true,
    );
  }

  void setStepAndPedestrianStatusStream() {
    final stepStream = Pedometer.stepCountStream;
    stepSubscription = stepStream.listen(
      (event) {
        service.invoke('onStepCountFromNative', {
          'stepsFromNative': event.steps,
        });
      },
      onDone: () {
        stepSubscription = null;
      },
      onError: (e) async {
        log('BackgroundService: pedometer stream error: $e');
        await stepSubscription?.cancel();
        stepSubscription = null;
      },
      cancelOnError: true,
    );

    final statusStream = Pedometer.pedestrianStatusStream;
    statusSubscription = statusStream.listen(
      (event) {
        service.invoke('onPedestrianStatusFromNative', {
          'status': event.status,
        });
      },
      onDone: () {
        statusSubscription = null;
      },
      onError: (e) async {
        log('BackgroundService: pedometer stream error: $e');
        await statusSubscription?.cancel();
        statusSubscription = null;
      },
      cancelOnError: true,
    );
  }

  Future<void> updateActivityAndLocationPermission() async {
    await PermissionManager.updateLocationAndActivityPemission();

    hasActivityPermission = PermissionManager.isActivityPermissionGrantedStatic;
    hasLocationPermission = PermissionManager.isLocationPermissionGrantedStatic;
  }

  bool setting = false;
  Future<void> safeSetStreams() async {
    if (setting) return;
    setting = true;
    try {
      await updateActivityAndLocationPermission();
      if (hasLocationPermission != true || hasActivityPermission != true) {
        await positionSubscription?.cancel();
        positionSubscription = null;

        await stepSubscription?.cancel();
        await statusSubscription?.cancel();

        stepSubscription = null;
        statusSubscription = null;
        return;
      }
      if (isHoliday) {
        await positionSubscription?.cancel();
        positionSubscription = null;
      } else if (positionSubscription == null) {
        try {
          final pos = await Geolocator.getCurrentPosition(
            locationSettings:
                const LocationSettings(accuracy: LocationAccuracy.best),
          );
          service.invoke('backgroundLocationUpdate', {
            'latitude': pos.latitude,
            'longitude': pos.longitude,
          });
        } catch (e) {
          log('getCurrentPosition error: $e');
        }

        setPositionStream();
      }
      if (stepSubscription == null || statusSubscription == null) {
        setStepAndPedestrianStatusStream();
      }
    } finally {
      setting = false;
    }
  }

  service.on("updateNotification").listen((event) {
    if (event == null) return;
    final String? title = event['title'];
    final String? content = event['content'];
    if (title != null && content != null) {
      if (service is AndroidServiceInstance) {
        service.setForegroundNotificationInfo(
          title: title,
          content: content,
        );
      }
    }
  });

  service.on("updateHolidayStatus").listen(
    (event) {
      if (event == null) return;

      final bool? value = event['isHoliday'];

      if (value != null) {
        isHoliday = value;

        safeSetStreams();
      }
      // BEATLogger.d('BackgroundService: isHoliday -> $isHoliday');
      log('BackgroundService: isHoliday -> $isHoliday');
    },
  );

  // stop 요청 처리
  service.on('stopService').listen((event) async {
    log('BackgroundService: stopService received');
    cancelAll();
    if (service is AndroidServiceInstance) {
      await service.stopSelf();
    }
  });

  // UI에서 동기화 second 설정 전달
  service.on('setSendToTime').listen((data) {
    if (data == null) return;
    final int? value = data['value'];
    if (value != null) {
      sendToTime = value;
      // BEATLogger.d('BackgroundService: setSendToTime -> $sendToTime');
      log('BackgroundService: setSendToTime -> $sendToTime');
    }
  });

  safeSetStreams();

  serviceStatusSub = Geolocator.getServiceStatusStream().listen(
    (s) {
      if (s == ServiceStatus.enabled) {
        safeSetStreams();
      } else {
        positionSubscription?.cancel();
        positionSubscription = null;
      }
    },
    onDone: () {
      serviceStatusSub = null;
    },
    onError: (e) async {
      log('BackgroundService: serviceStatusSub stream error: $e');
      await serviceStatusSub?.cancel();
      serviceStatusSub = null;
    },
    cancelOnError: true,
  );

  permissionCheckTimer = Timer.periodic(const Duration(seconds: 30), (_) {
    safeSetStreams();
  });

  // 자정(테스트: 5분마다 0초)에 리셋 트리거
  midnightTimer = Timer.periodic(const Duration(seconds: 1), (_) {
    final now = DateTime.now();
    if (now.hour == 0 && now.minute == 0 && now.second == 0) {
    // if (now.minute % 5 == 0 && now.second == 0) {
      service.invoke('midnightReset');
    }
  });

  // 1시간마다 동기화 트리거
  hourlySyncTimer = Timer.periodic(const Duration(hours: 1), (_) async {
    if ((hasActivityPermission ?? false) && (hasLocationPermission ?? false)) {
      service.invoke('syncWalkDataInBackground');
    }
  });

  // 3분 주기 특정 초에 랭킹 동기화 트리거
  rankSyncTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
    if ((hasActivityPermission ?? false) && (hasLocationPermission ?? false)) {
      final now = DateTime.now();
      if (now.minute == 59 && now.second == sendToTime) {
      // if (now.minute % 3 == 0 && now.second == sendToTime) {
        service.invoke('syncRankingInBackground');
      }
    }
  });

  service.invoke('bg_ready');
}

@pragma('vm:entry-point')
Future<void> startServiceIOS(ServiceInstance service) async {}

@pragma('vm:entry-point')
Future<bool> startBackgroundServiceIOS(ServiceInstance service) async {
  return true;
}
