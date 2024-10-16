import 'package:flutter/material.dart';

import 'palette.dart';

ColorScheme get lightColorScheme => ColorScheme(
      brightness: Brightness.light,
      primary: Palette.primary,
      onPrimary: Palette.lightOnPrimary,
      secondary: const Color(0xffffffff),
      onSecondary: const Color(0xff000000),
      error: Palette.error,
      onError: Palette.onError,
      surface: const Color(0xfff5f5f5),
      onSurface: const Color(0xff000000),
    );
