import 'package:flutter/material.dart';

import 'palette.dart';

ColorScheme get darkColorScheme => ColorScheme(
      brightness: Brightness.dark,
      primary: Palette.primary,
      onPrimary: Palette.darkOnPrimary,
      secondary: Palette.secondary,
      onSecondary: Palette.darkOnSecondary,
      error: Palette.error,
      onError: Palette.onError,
      surface: Palette.darkSurface,
      onSurface: Palette.darkOnSurface,
    );
