import 'dart:developer';
import 'package:flutter/material.dart';

class NavigatorKeyManager {
  static final NavigatorKeyManager _instance = NavigatorKeyManager._internal();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
  NavigatorState? get navigatorState => _navigatorKey.currentState;

  NavigatorKeyManager._internal(){
    log("NavigatorKeyManager created.");
  }

  factory NavigatorKeyManager() {
    return _instance;
  }
}