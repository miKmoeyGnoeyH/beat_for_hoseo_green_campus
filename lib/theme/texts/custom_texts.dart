import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'fontweights.dart';

abstract class CustomLargeTexts {
  static const double letterSpacing = 0;

  static TextStyle get headlineLarge => TextStyle(
    fontFamily: "Pretendard",
    fontSize: 36.0.w,
    fontWeight: FontWeights.medium,
    letterSpacing: letterSpacing,
  );
  static TextStyle get headlineMedium => TextStyle(
    fontFamily: "Pretendard",
    fontSize: 26.0.w,
    fontWeight: FontWeights.medium,
    letterSpacing: letterSpacing,
  );
  static TextStyle get headlineSmall => TextStyle(
    fontFamily: "Pretendard",
    fontSize: 22.0.w,
    fontWeight: FontWeights.medium,
    letterSpacing: letterSpacing,
  );

  static TextStyle get displayLarge => TextStyle(
    fontFamily: "Pretendard",
    fontSize: 36.0.w,
    fontWeight: FontWeights.regular,
    letterSpacing: letterSpacing,
  );
  static TextStyle get displayMedium => TextStyle(
    fontFamily: "Pretendard",
    fontSize: 26.0.w,
    fontWeight: FontWeights.regular,
    letterSpacing: letterSpacing,
  );
  static TextStyle get displaySmall => TextStyle(
    fontFamily: "Pretendard",
    fontSize: 22.0.w,
    fontWeight: FontWeights.regular,
    letterSpacing: letterSpacing,
  );

  static TextStyle get titleLarge => TextStyle(
    fontFamily: "Pretendard",
    fontSize: 22.0.w,
    fontWeight: FontWeights.medium,
    letterSpacing: letterSpacing,
  );
  static TextStyle get titleMedium => TextStyle(
    fontFamily: "Pretendard",
    fontSize: 18.0.w,
    fontWeight: FontWeights.medium,
    letterSpacing: letterSpacing,
  );
  static TextStyle get titleSmall => TextStyle(
    fontFamily: "Pretendard",
    fontSize: 16.0.w,
    fontWeight: FontWeights.medium,
    letterSpacing: letterSpacing,
  );

  static TextStyle get subtitleLarge => TextStyle(
    fontFamily: "Pretendard",
    fontSize: 18.0.w,
    fontWeight: FontWeights.medium,
    letterSpacing: letterSpacing,
  );
  static TextStyle get subtitleMedium => TextStyle(
    fontFamily: "Pretendard",
    fontSize: 16.0.w,
    fontWeight: FontWeights.medium,
    letterSpacing: letterSpacing,
  );
  static TextStyle get subtitleSmall => TextStyle(
    fontFamily: "Pretendard",
    fontSize: 14.0.w,
    fontWeight: FontWeights.medium,
    letterSpacing: letterSpacing,
  );

  static TextStyle get hintStyle => TextStyle(
    fontFamily: "Pretendard",
    fontSize: 26.0.w,
    fontWeight: FontWeights.regular,
    letterSpacing: letterSpacing,
  );

  static TextStyle get bodyLarge => TextStyle(
    fontFamily: "Pretendard",
    fontSize: 16.0.w,
    fontWeight: FontWeights.regular,
    letterSpacing: letterSpacing,
  );
  static TextStyle get bodyMedium => TextStyle(
    fontFamily: "Pretendard",
    fontSize: 14.0.w,
    fontWeight: FontWeights.regular,
    letterSpacing: letterSpacing,
  );
  static TextStyle get bodySmall => TextStyle(
    fontFamily: "Pretendard",
    fontSize: 12.0.w,
    fontWeight: FontWeights.regular,
    letterSpacing: letterSpacing,
  );

  static TextStyle get labelLarge => TextStyle(
    fontFamily: "Pretendard",
    fontSize: 16.0.w,
    fontWeight: FontWeights.regular,
    letterSpacing: letterSpacing,
  );
  static TextStyle get labelMedium => TextStyle(
    fontFamily: "Pretendard",
    fontSize: 14.0.w,
    fontWeight: FontWeights.regular,
    letterSpacing: letterSpacing,
  );
  static TextStyle get labelSmall => TextStyle(
    fontFamily: "Pretendard",
    fontSize: 12.0.w,
    fontWeight: FontWeights.regular,
    letterSpacing: letterSpacing,
  );
}

// abstract class CustomDefaultTexts {
//   static const double letterSpacing = 0;
//
//   static TextStyle get headlineLarge => TextStyle(
//     fontSize: 34.0.w,
//     fontWeight: FontWeights.medium,
//     letterSpacing: letterSpacing,
//   );
//   static TextStyle get headlineMedium => TextStyle(
//     fontSize: 24.0.w,
//     fontWeight: FontWeights.medium,
//     letterSpacing: letterSpacing,
//   );
//   static TextStyle get headlineSmall => TextStyle(
//     fontSize: 20.0.w,
//     fontWeight: FontWeights.medium,
//     letterSpacing: letterSpacing,
//   );
//
//   static TextStyle get displayLarge => TextStyle(
//     fontSize: 34.0.w,
//     fontWeight: FontWeights.regular,
//     letterSpacing: letterSpacing,
//   );
//   static TextStyle get displayMedium => TextStyle(
//     fontSize: 24.0.w,
//     fontWeight: FontWeights.regular,
//     letterSpacing: letterSpacing,
//   );
//   static TextStyle get displaySmall => TextStyle(
//     fontSize: 20.0.w,
//     fontWeight: FontWeights.regular,
//     letterSpacing: letterSpacing,
//   );
//
//   static TextStyle get titleLarge => TextStyle(
//     fontSize: 20.0.w,
//     fontWeight: FontWeights.medium,
//     letterSpacing: letterSpacing,
//   );
//   static TextStyle get titleMedium => TextStyle(
//     fontSize: 16.0.w,
//     fontWeight: FontWeights.medium,
//     letterSpacing: letterSpacing,
//   );
//   static TextStyle get titleSmall => TextStyle(
//     fontSize: 14.0.w,
//     fontWeight: FontWeights.medium,
//     letterSpacing: letterSpacing,
//   );
//
//   static TextStyle get subtitleLarge => TextStyle(
//     fontSize: 16.0.w,
//     fontWeight: FontWeights.medium,
//     letterSpacing: letterSpacing,
//   );
//   static TextStyle get subtitleMedium => TextStyle(
//     fontSize: 14.0.w,
//     fontWeight: FontWeights.medium,
//     letterSpacing: letterSpacing,
//   );
//   static TextStyle get subtitleSmall => TextStyle(
//     fontSize: 12.0.w,
//     fontWeight: FontWeights.medium,
//     letterSpacing: letterSpacing,
//   );
//
//   static TextStyle get bodyLLarge => TextStyle(
//     fontSize: 16.0.w,
//     fontWeight: FontWeights.regular,
//     letterSpacing: letterSpacing,
//   );
//   static TextStyle get bodyLarge => TextStyle(
//     fontSize: 14.0.w,
//     fontWeight: FontWeights.regular,
//     letterSpacing: letterSpacing,
//   );
//   static TextStyle get bodyMedium => TextStyle(
//     fontSize: 12.0.w,
//     fontWeight: FontWeights.regular,
//     letterSpacing: letterSpacing,
//   );
//   static TextStyle get bodySmall => TextStyle(
//     fontSize: 10.0.w,
//     fontWeight: FontWeights.regular,
//     letterSpacing: letterSpacing,
//   );
//
//   static TextStyle get labelLarge => TextStyle(
//     fontSize: 14.0.w,
//     fontWeight: FontWeights.regular,
//     letterSpacing: letterSpacing,
//   );
//   static TextStyle get labelMedium => TextStyle(
//     fontSize: 12.0.w,
//     fontWeight: FontWeights.regular,
//     letterSpacing: letterSpacing,
//   );
//   static TextStyle get labelSmall => TextStyle(
//     fontSize: 10.0.w,
//     fontWeight: FontWeights.regular,
//     letterSpacing: letterSpacing,
//   );
// }