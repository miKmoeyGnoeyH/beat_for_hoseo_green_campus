import 'dart:io';

import 'package:beat_flutter/managers/prefs/prefs_manager.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:permission_handler/permission_handler.dart';

/// 권한 관리를 담당하는 클래스
abstract class PermissionManager {
  static const _channel = MethodChannel("com.beat.walkreport/pedometer");

  static bool? isLocationPermissionGrantedStatic;
  static bool? isActivityPermissionGrantedStatic;

  final List<Permission> permissions = [
    Permission.camera,
    Permission.notification,
    Permission.locationWhenInUse,
    Permission.locationAlways,
    Permission.activityRecognition,
  ];

  static Future<void> ensureLocationAndActivityPermissionInitialized() async {
    if (isLocationPermissionGrantedStatic == null || isActivityPermissionGrantedStatic == null) {
      await updateLocationAndActivityPemission();
    }
  }

  /// 카메라 권한 요청
  static Future<bool> requestCameraPermission() async {
    final cameraStatus = await Permission.camera.request();
    return cameraStatus.isGranted;
  }

  /// 카메라 권한이 부여되었는지 확인
  static Future<bool> isCameraPermissionGranted() async {
    final cameraStatus = await Permission.camera.status;
    return cameraStatus.isGranted;
  }

  /// 카메라 권한이 거부되었는지 확인
  Future<bool> isCameraPermissionDenied() async {
    final cameraStatus = await Permission.camera.status;
    return !cameraStatus.isGranted;
  }

  /// 알림 권한 요청
  /// 스플래시 스크린에서 알림 원한을 요청하는데,
  /// 이 때 학번, 비밀번호가 저장되어 있으면 로그인 이후 홈 화면에 진입할 때 스플래시 스크린을 제거하고
  /// 학번 혹은 비밀번호가 저장되어 있지 않다면 권한 요청 이후 스플래시 스크린을 제거함.
  static Future<bool> requestNotificationPermission() async {
    final notificationStatus = await Permission.notification.request();

    if (!PrefsManager().isStudentIdSaved() || !PrefsManager().isPasswordSaved()) {
      // FlutterNativeSplash.remove();
    }

    return notificationStatus.isGranted;
  }

  /// 알림 권한이 부여되었는지 확인
  static Future<bool> isNotificationPermissionGranted() async {
    final notificationStatus = await Permission.notification.status;
    return notificationStatus.isGranted;
  }

  /// 위치 권한 요청 (앱 사용 중에만)
  static Future<bool> requestLocationWhenInUserPermission() async {
    final locationWhenInUseStatus = await Permission.locationWhenInUse.request();
    return locationWhenInUseStatus.isGranted;
  }

  /// 위치 권한이 부여되었는지 확인 (앱 사용 중에만)
  static Future<bool> isLocationWhenInUsePermissionGranted() async {
    final locationWhenInUseStatus = await Permission.locationWhenInUse.status;
    return locationWhenInUseStatus.isGranted;
  }

  /// 위치 권한 요청 (항상)
  static Future<bool> requestLocationAlwaysPermission() async {
    final locationAlwaysStatus = await Permission.locationAlways.request();
    return locationAlwaysStatus.isGranted;
  }

  /// 위치 권한이 부여되었는지 확인 (항상)
  static Future<bool> isLocationAlwaysPermissionGranted() async {
    final locationAlwaysStatus = await Permission.locationAlways.status;
    return locationAlwaysStatus.isGranted;
  }

  /// 위치 권한 요청 (앱 사용 중이거나 항상)
  static Future<bool> requestLocationPermission() async {
    final isLocationWhenInUseGranted = await PermissionManager.requestLocationWhenInUserPermission();
    late final bool isLocationAlwaysGranted;

    if (isLocationWhenInUseGranted) {
      isLocationAlwaysGranted = await PermissionManager.requestLocationAlwaysPermission();
    } else {
      isLocationAlwaysGranted = false;
    }

    return isLocationWhenInUseGranted || isLocationAlwaysGranted;
  }

  /// 위치 권한이 부여되었는지 확인 (앱 사용 중이거나 항상)
  static Future<bool> isLocationPermissionGranted() async {
    final isLocationWhenInUseGranted = await PermissionManager.isLocationWhenInUsePermissionGranted();
    final isLocationAlwaysGranted = await PermissionManager.isLocationAlwaysPermissionGranted();

    // 포어그라운드 동작 허용: 앱 사용 중 혹은 항상 허용 중 하나만 있어도 true
    return isLocationWhenInUseGranted || isLocationAlwaysGranted;
  }

  /// 활동 인식 권한 요청
  static Future<bool> requestActivityPermission() async {
    final activityRecognitionStatus = await Permission.activityRecognition.request();
    return await isActivityPermissionGranted();
  }

  /// 활동 인식 권한이 부여되었는지 확인
  static Future<bool> isActivityPermissionGranted() async {
    if (Platform.isIOS) {
      final result = await _channel.invokeMethod("isMotionPermissionGranted");
      return result;
    } else {
      final activityRecognitionStatus =
      await Permission.activityRecognition.status;
      return activityRecognitionStatus.isGranted;
    }
  }

  /// 위치 및 활동 인식 권한 상태를 업데이트
  static Future<void> updateLocationAndActivityPemission() async {
    isLocationPermissionGrantedStatic = await isLocationPermissionGranted();
    isActivityPermissionGrantedStatic = await isActivityPermissionGranted();
  }
}