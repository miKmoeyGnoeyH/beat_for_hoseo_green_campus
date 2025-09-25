import 'dart:async';
import 'dart:ui';
import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/logger/beat_logger.dart';
import 'package:beat_flutter/managers/permission/permission_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:easy_localization/easy_localization.dart';

 


/// 포어그라운드에서는 안드로이드와 iOS 동작이 동일함
@pragma('vm:entry-point')
void startPedometerTimerForeground(ServiceInstance service) {
  // await DotEnvManager().ensureInitialized();
  // WidgetsFlutterBinding.ensureInitialized();
  // DartPluginRegistrant.ensureInitialized();
  // await EasyLocalization.ensureInitialized();

  return;
}

/// 백그라운드 서비스 타이머 시작
/// 안드로이드는 포어그라운드와 동일한 메소드를 사용하므로
/// iOS에서 메소드 채널을 설정
@pragma('vm:entry-point')
Future<bool> startPedometerTimerBackgroundIOS(ServiceInstance service) async {
  await DotEnvManager().ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await BEATLogger.ensureInitialized();

  await PermissionManager.updateLocationAndActivityPemission();

  return true;
}

@pragma('vm:entry-point')
void startLocationTimerForeground(ServiceInstance service) async {
  return;
}

/// 통합 서비스용 진입점 (ActivityServiceController)
@pragma('vm:entry-point')
void startActivityServiceForeground(ServiceInstance service) {
  // 통합 서비스 포어그라운드 진입점: 필요 시 알림/핸들러 구성
  final LocalizationManager localizationManager = LocalizationManager();

  final backgroundService = FlutterBackgroundService();
  backgroundService.invoke("updateNotification", {
    "title": localizationManager.generalInitialNotificationTitle,
    "content": localizationManager.generalInitialNotificationContent,
  });

  return;
}

@pragma('vm:entry-point')
Future<bool> startActivityServiceBackgroundIOS(ServiceInstance service) async {
  await DotEnvManager().ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await BEATLogger.ensureInitialized();

  await PermissionManager.updateLocationAndActivityPemission();

  final LocalizationManager localizationManager = LocalizationManager();
  final backgroundService = FlutterBackgroundService();

  backgroundService.invoke("updateNotification", {
    "title": localizationManager.generalInitialNotificationTitle,
    "content": localizationManager.generalInitialNotificationContent,
  });

  return true;
}

@pragma('vm:entry-point')
Future<bool> startLocationTimerBackgroundIOS(ServiceInstance service) async {
  await DotEnvManager().ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await BEATLogger.ensureInitialized();

  await PermissionManager.updateLocationAndActivityPemission();

  return true;
}