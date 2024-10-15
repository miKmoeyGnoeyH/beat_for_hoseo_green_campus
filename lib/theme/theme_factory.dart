import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'colors/dark_color.dart';
import 'colors/light_color.dart';
import 'texts/dark_text.dart';
import 'texts/light_text.dart';

abstract class ThemeFactory {
  static ThemeData get getThemeDataDependsOnSystemBrightness {
    switch (systemBrightness) {
      case Brightness.dark:
        return darkTheme;
      case Brightness.light:
        return lightTheme;
      default:
        return lightTheme;
    }
  }

  static Brightness get systemBrightness =>
      SchedulerBinding.instance.platformDispatcher.platformBrightness;

  static ThemeData get lightTheme => ThemeData(
    colorScheme: lightColorScheme,
    textTheme: lightTextTheme,
  );

  static ThemeData get darkTheme => ThemeData(
    colorScheme: darkColorScheme,
    textTheme: darkTextTheme,
  );
}
