import 'package:flutter/material.dart';

import '../colors/palette.dart';

TextTheme get darkTextTheme => TextTheme(
  headlineLarge: TextStyle(
    fontSize: 96.0,
    fontWeight: FontWeight.w300,
    color: Palette.darkText,
  ),
  headlineMedium: TextStyle(
    fontSize: 60.0,
    fontWeight: FontWeight.w300,
    color: Palette.darkText,
  ),
  headlineSmall: TextStyle(
    fontSize: 48.0,
    fontWeight: FontWeight.w400,
    color: Palette.darkText,
  ),
  titleLarge: TextStyle(
    fontSize: 34.0,
    fontWeight: FontWeight.w400,
    color: Palette.darkText,
  ),
  titleMedium: TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w400,
    color: Palette.darkText,
  ),
  titleSmall: TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
    color: Palette.darkText,
  ),
  bodyLarge: TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: Palette.darkText,
  ),
  bodyMedium: TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: Palette.darkText,
  ),
  labelLarge: TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: Palette.darkText,
  ),
);