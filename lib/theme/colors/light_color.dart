import 'package:flutter/material.dart';

import 'palette.dart';

ColorScheme get lightColorScheme => ColorScheme(
      brightness: Brightness.light,
      primary: Palette.primary,
      onPrimary: Palette.lightOnPrimary,
      secondary: Palette.secondary,
      onSecondary: Palette.lightOnSecondary,
      error: Palette.error,
      onError: Palette.onError,
      surface: Palette.lightSurface,
      onSurface: Palette.lightOnSurface,
    );
