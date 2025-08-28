import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  static final PermissionManager _instance = PermissionManager._internal();
  PermissionManager._internal();
  factory PermissionManager() => _instance;

  final List<Permission> permissions = [
    Permission.storage,
    Permission.camera,
    Permission.notification,
    Permission.activityRecognition,
  ];

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> status = await permissions.request();
    // log(status.map((key, value) => MapEntry(key, value.toString())).toString());
  }
}