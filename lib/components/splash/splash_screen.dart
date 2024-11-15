import 'dart:async';
import 'dart:developer';

import 'package:Beat/managers/navigator/navigator_key_manager.dart';
import 'package:Beat/managers/navigator/routes.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final List<Permission> permissions = [
    Permission.storage,
    Permission.camera,
    Permission.notification,
  ];

  @override
  void initState() async {
    Map<Permission, PermissionStatus> status = await permissions.request();

    log(status.map((key, value) => MapEntry(key, value.toString())).toString());

    Timer(
      const Duration(seconds: 1),
      () => NavigatorKeyManager().pushNamedAndRemoveUntil(RouteNames.signIn),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset('assets/images/beat_splash'),
    );
  }
}
