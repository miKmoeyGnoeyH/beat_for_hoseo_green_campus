import 'dart:ui';

abstract class Palette {
  static Color get hoseoBlue => const Color(0xff222BA3);
  static Color get hoseoSkyBlue => const Color(0xff03a1ac);
  static Color get hoseoRed => const Color(0xFFa30c1a);
  static Color get hoseoGray => const Color(0xff5e5a57);
  static Color get hoseoWhite => const Color(0xffe5e5e5);

  static Color get pendingBackground => const Color(0xffF0F0F0);

  static Color get inProgressBackground => const Color(0xffEEF9EB);
  static Color get inProgressText => const Color(0xff2EAF0A);

  static Color get underReviewBackground => const Color(0xffFFF5EC);
  static Color get underReviewText => const Color(0xffFF8416);

  static Color get endedBackground => const Color(0xffFEEFEF);
  static Color get endedText => const Color(0xffF23D3D);
}