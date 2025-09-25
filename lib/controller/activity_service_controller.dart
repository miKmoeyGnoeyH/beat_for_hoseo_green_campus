import 'dart:io';

import 'package:beat_flutter/controller/location/location_controller.dart';
import 'package:beat_flutter/controller/pedometer/pedometer_controller.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/permission/permission_manager.dart';
import 'package:beat_flutter/managers/background_service/background_service_entry.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';

/// Pedometer + Location을 하나의 백그라운드 서비스로 오케스트레이션하는 컨트롤러
class ActivityServiceController extends GetxController {
  late final PedometerController pedometerController;
  late final LocationController locationController;

  ActivityServiceController() {
    pedometerController = Get.find<PedometerController>();
    locationController = Get.find<LocationController>();
  }

  /// 단일 백그라운드 서비스 초기화 (부팅 자동 시작 비활성화)
  Future<void> initializeService() async {
    final LocalizationManager localizationManager = LocalizationManager();

    final service = FlutterBackgroundService();
    await service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: startActivityServiceForeground,
        onBackground: startActivityServiceBackgroundIOS,
      ),
      androidConfiguration: AndroidConfiguration(
        autoStart: false,
        onStart: startActivityServiceForeground,
        isForegroundMode: true,
        autoStartOnBoot: false,
        notificationChannelId: "activity_service_channel",
        initialNotificationTitle: "BEAT is running",
        initialNotificationContent: "Tracking steps and location in background",
      ),
    );
  }

  /// 앱 포어그라운드 진입 시 호출: 두 컨트롤러 모두 포어그라운드 모드 시작
  Future<void> startForegroundService() async {
    await PermissionManager.updateLocationAndActivityPemission();
    pedometerController.startForegroundService();
    locationController.startForegroundService();
  }

  Future<void> stopForegroundService() async {
    await pedometerController.stopForegroundService();
    await locationController.stopForegroundService();
  }

  /// 앱 백그라운드/종료 시 호출: 필요한 타이머/작업을 시작하고 서비스는 한 번만 시작
  Future<void> startBackgroundService() async {
    await PermissionManager.updateLocationAndActivityPemission();

    if (Platform.isIOS) {
      // iOS는 기존 컨트롤러 로직을 활용 (네이티브 스케줄링 포함)
      locationController.startBackgroundService();
      pedometerController.startBackgroundService();
    } else {
      // Android는 단일 서비스 하에서 내부 타이머들을 직접 가동
      pedometerController.initPlatformState();
      pedometerController.startReportTimer();
      pedometerController.startRankReportTimer();
      pedometerController.getWalkHitory();

      await locationController.fetchLocation();
      locationController.checkIsValidArea();
      locationController.startMidnightTimer();
      locationController.startUpdateLocationTimer();
    }

    FlutterBackgroundService().startService();
  }

  Future<void> stopBackgroundService() async {
    await pedometerController.stopBackgroundService();
    await locationController.stopBackgroundService();
  }

  /// 라우팅 인자 위임용 API
  void setAuthorization(String authorization) {
    pedometerController.setAuthorization(authorization);
  }

  void setSendToTime(int value) {
    pedometerController.setSendToTime(value);
  }

  Future<void> getWalkHistory() async {
    await pedometerController.getWalkHitory();
  }
}

