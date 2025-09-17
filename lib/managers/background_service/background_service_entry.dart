import 'dart:async';
import 'dart:ui';
import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:beat_flutter/managers/logger/beat_logger.dart';
import 'package:beat_flutter/managers/prefs/prefs_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:beat_flutter/controller/pedometer/pedometer_controller.dart';
import 'package:beat_flutter/controller/location/location_controller.dart';

/// iOS background entrypoint (Location)
@pragma('vm:entry-point')
Future<bool> locationServiceIosBackground(ServiceInstance service) async {
  await DotEnvManager().ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  return true;
}

/// iOS background entrypoint (Pedometer)
@pragma('vm:entry-point')
Future<bool> pedometerServiceIosBackground(ServiceInstance service) async {
  await DotEnvManager().ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  return true;
}

/// Android/iOS Foreground entrypoint (Location)
@pragma('vm:entry-point')
void locationServiceStart(ServiceInstance service) async {
  await DotEnvManager().ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await PrefsManager().init();
  final locationController = Get.put(LocationController());
  locationController.startTimer(service);
}

/// Android/iOS Foreground entrypoint (Pedometer)
@pragma('vm:entry-point')
void pedometerServiceStart(ServiceInstance service) async {
  await DotEnvManager().ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await PrefsManager().init();
  final pedometerController = Get.put(PedometerController());
  pedometerController.startTimer(service);
}