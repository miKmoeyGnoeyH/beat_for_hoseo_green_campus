import 'package:flutter/material.dart';

import '../colors/palette.dart';
import 'fontweights.dart';

final Color color = Palette.lightText;

TextTheme get lightTextTheme => TextTheme(
  displayLarge: TextStyle(
    fontSize: 96.0,
    fontWeight: FontWeights.light,
    color: color,
  ),
  displayMedium: TextStyle(
    fontSize: 60.0,
    fontWeight: FontWeights.light,
    color: color,
  ),
  displaySmall: TextStyle(
    fontSize: 48.0,
    fontWeight: FontWeights.regular,
    color: color,
  ),
  headlineLarge: TextStyle(
    fontSize: 34.0,
    fontWeight: FontWeights.regular,
    color: color,
  ),
  headlineMedium: TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeights.regular,
    color: color,
  ),
  headlineSmall: TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeights.medium,
    color: color,
  ),
  titleLarge: TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeights.medium,
    color: color,
  ),
  titleMedium: TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeights.medium,
    color: color,
  ),
  bodyLarge: TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeights.regular,
    color: color,
  ),
  bodyMedium: TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeights.regular,
    color: color,
  ),
  labelLarge: TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeights.regular,
    color: color.withOpacity(0.5),
  ),
);