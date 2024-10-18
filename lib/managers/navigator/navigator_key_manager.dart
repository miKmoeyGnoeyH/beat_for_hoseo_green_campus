import 'dart:developer';
import 'package:flutter/material.dart';

class NavigatorKeyManager {
  static final NavigatorKeyManager _instance = NavigatorKeyManager._internal();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  Object? _arguments;

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  NavigatorState? get navigatorState => _navigatorKey.currentState;

  factory NavigatorKeyManager() => _instance;

  NavigatorKeyManager._internal() {
    log("NavigatorKeyManager created.");
  }

  Object? get arguments {
    Object? ret = _arguments;
    _arguments = null;
    return ret;
  }

  void pop() {
    navigatorState?.pop();
    _arguments = null;
  }

  void pushNamed(String routeName, {Object? arguments}) {
    _arguments = arguments;
    navigatorState?.pushNamed(routeName);
  }
}
