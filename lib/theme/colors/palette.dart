import 'dart:ui';

abstract class Palette {
  static Color get primary => const Color(0xff222BA3);
  static Color get secondary => const Color(0xff03a1ac);
  static Color get tertiary => const Color(0xFFa30c1a);
  static Color get quarternary => const Color(0xff5e5a57);
  static Color get quinary => const Color(0xffe5e5e5);

  static Color get lightSurface => const Color(0xffFFFFFF);
  static Color get lightOnSurface => const Color(0xff000000);
  static Color get lightOnPrimary => const Color(0xffffffff);
  static Color get lightOnSecondary => const Color(0xffffffff);
  static Color get lightOnTertiary => const Color(0xffffffff);
  static Color get lightOnQuarternary => const Color(0xffffffff);
  static Color get lightOnQuinary => const Color(0xffffffff);
  static Color get lightText => const Color(0xff000000);

  static Color get darkSurface => const Color(0xff000000);
  static Color get darkOnSurface => const Color(0xffFFFFFF);
  static Color get darkOnPrimary => const Color(0xffffffff);
  static Color get darkOnSecondary => const Color(0xffffffff);
  static Color get darkOnTertiary => const Color(0xffffffff);
  static Color get darkOnQuarternary => const Color(0xffffffff);
  static Color get darkOnQuinary => const Color(0xffffffff);
  static Color get darkText => const Color(0xffFFFFFF);

  static Color get error => const Color(0xffff0000);
  static Color get onError => const Color(0xffffffff);
}