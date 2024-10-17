import 'package:flutter/material.dart';

import 'fontweights.dart';

abstract class CustomTexts {
  static const double letterSpacing = 0;

  static TextStyle get headlineLarge => TextStyle(
    fontSize: 34.0,
    fontWeight: FontWeights.medium,
    letterSpacing: letterSpacing,
  );
  static TextStyle get headlineMedium => TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeights.medium,
    letterSpacing: letterSpacing,
  );
  static TextStyle get headlineSmall => TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeights.medium,
    letterSpacing: letterSpacing,
  );

  static TextStyle get titleLarge => TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeights.medium,
    letterSpacing: letterSpacing,
  );
  static TextStyle get titleMedium => TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeights.medium,
    letterSpacing: letterSpacing,
  );
  static TextStyle get titleSmall => TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeights.medium,
    letterSpacing: letterSpacing,
  );

  static TextStyle get subtitleLarge => TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeights.regular,
    letterSpacing: letterSpacing,
  );
  static TextStyle get subtitleMedium => TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeights.regular,
    letterSpacing: letterSpacing,
  );
  static TextStyle get subtitleSmall => TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeights.regular,
    letterSpacing: letterSpacing,
  );

  static TextStyle get bodyLarge => TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeights.regular,
    letterSpacing: letterSpacing,
  );
  static TextStyle get bodyMedium => TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeights.regular,
    letterSpacing: letterSpacing,
  );
  static TextStyle get bodySmall => TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeights.regular,
    letterSpacing: letterSpacing,
  );

  static TextStyle get labelLarge => TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeights.regular,
    letterSpacing: letterSpacing,
  );
  static TextStyle get labelMedium => TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeights.regular,
    letterSpacing: letterSpacing,
  );
  static TextStyle get labelSmall => TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeights.regular,
    letterSpacing: letterSpacing,
  );
}