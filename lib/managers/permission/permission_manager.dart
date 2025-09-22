import 'dart:developer';
import 'dart:io';

import 'package:beat_flutter/managers/prefs/prefs_manager.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  static const _channel = MethodChannel("com.beat.walkreport/channel");

  static final PermissionManager _instance = PermissionManager._internal();

  PermissionManager._internal();

  factory PermissionManager() => _instance;

  final List<Permission> permissions = [
    // Permission.storage,
    Permission.camera,
    Permission.notification,
    // Permission.location,
    Permission.locationWhenInUse,
    Permission.locationAlways,
    Permission.activityRecognition,
  ];

  Future<void> requestPermissions() async {
    // 1. WhenInUse 먼저 요청
    final whenInUseStatus = await Permission.locationWhenInUse.request();

    // 2. 허용되었을 경우에만 Always 요청
    if (whenInUseStatus.isGranted) {
      await Permission.locationAlways.request();
    }

    final cameraStatus = await Permission.camera.request();
    final notificationStatus = await Permission.notification.request();
    final activityRecognitionStatus = await Permission.activityRecognition.request();

    // 3. 나머지 권한 요청
    // await [
    //   Permission.camera,
    //   Permission.notification,
    //   Permission.activityRecognition,
    // ].request();

    if (!PrefsManager().isStudentIdSaved() || !PrefsManager().isPasswordSaved()) {
      FlutterNativeSplash.remove();
      return;
    }
  }

  Future<bool> requestPedometerPermission() async {
    final whenInUseStatus = await Permission.locationWhenInUse.request();

    if (whenInUseStatus.isGranted) {
      await Permission.locationAlways.request();
    }

    final activityRecognitionStatus = await Permission.activityRecognition.request();

    return whenInUseStatus.isGranted || activityRecognitionStatus.isGranted;
  }

  Future<bool> requestLocationPermission() async {
    final whenInUseStatus = await Permission.locationWhenInUse.request();
    late final PermissionStatus alwaysStatus;

    if (whenInUseStatus.isGranted) {
      alwaysStatus = await Permission.locationAlways.request();
    }

    return whenInUseStatus.isGranted || alwaysStatus.isGranted;
  }

  Future<bool> requestActivityPermission() async {
    final activityRecognitionStatus = await Permission.activityRecognition.request();
    // 권한 요청 후 실제 권한 상태를 Android/iOS 통일된 방식으로 확인
    return await isActivityPermissionDenied();
  }

  Future<bool> requestNotificationPermission() async {
    final notificationStatus = await Permission.notification.request();

    if (!PrefsManager().isStudentIdSaved() || !PrefsManager().isPasswordSaved()) {
      log("isStudentIdSaved or isPasswordSaved is false");
      FlutterNativeSplash.remove();
    }
    return notificationStatus.isGranted;
  }

  Future<bool> requestCameraPermission() async {
    final cameraStatus = await Permission.camera.request();
    return cameraStatus.isGranted;
  }

  Future<bool> isLocationPermissionDenied() async {
    final whenInUseStatus = await Permission.locationWhenInUse.status;
    final alwaysStatus = await Permission.locationAlways.status;
    return !whenInUseStatus.isGranted || !alwaysStatus.isGranted;
  }


  static Future<bool> isActivityPermissionDenied() async {
    if (Platform.isIOS) {
      final result = await _channel.invokeMethod("isMotionPermissionGranted");
      return result != true;
    } else {
      final activityRecognitionStatus =
          await Permission.activityRecognition.status;

      // log("PermissionManager : isActivityPermissionDenied() : activityRecognitionStatus : $activityRecognitionStatus");

      return !activityRecognitionStatus.isGranted;
    }
  }

  Future<bool> isCameraPermissionDenied() async {
    final cameraStatus = await Permission.camera.status;
    return !cameraStatus.isGranted;
  }
}
