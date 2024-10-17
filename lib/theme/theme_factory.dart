import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'colors/custom_dark_colors.dart';
import 'colors/custom_light_colors.dart';
import 'colors/if_custom_colors.dart';


abstract class ThemeFactory {
  static CustomColors get getAppColorsDependsOnSystemBrightness {
    switch (systemBrightness) {
      case Brightness.dark:
        return CustomDarkColors();
      case Brightness.light:
        return CustomLightColors();
      default:
        return CustomLightColors();
    }
  }

  static Brightness get systemBrightness =>
      SchedulerBinding.instance.platformDispatcher.platformBrightness;
}
