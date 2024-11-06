import 'dart:developer';
import 'package:BEAT/managers/navigator/routes.dart';
import 'package:flutter/material.dart';

class NavigatorKeyManager {
  static final NavigatorKeyManager _instance = NavigatorKeyManager._internal();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  NavigatorState? get navigatorState => _navigatorKey.currentState;

  factory NavigatorKeyManager() => _instance;

  NavigatorKeyManager._internal() {
    log("navigator_key_manager : NavigatorKeyManager created.");
  }

  void pop() {
    navigatorState?.pop();
  }

  void popUntil(String routeName) {
    navigatorState?.popUntil((route) => route.settings.name == routeName);
  }

  void pushNamed(String routeName, {Object? arguments}) {
    navigatorState?.pushNamed(routeName, arguments: arguments);
  }

  void pushNamedAndRemoveUntil(String routeName) {
    navigatorState?.pushNamedAndRemoveUntil(routeName, (route) => false);
  }
}
