import 'package:beat_flutter/managers/prefs/prefs_manager.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
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
}
