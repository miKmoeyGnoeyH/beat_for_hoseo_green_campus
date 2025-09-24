import 'package:flutter/material.dart';

import 'if_custom_colors.dart';

class CustomDarkColors implements CustomColors {
  @override
  Color get primary => const Color(0xff222BA3);

  @override
  Color get onPrimary => const Color(0xffffffff);

  @override
  Color get secondary => Colors.transparent;

  @override
  Color get onSecondary => Colors.transparent;

  @override
  Color get tertiary => Colors.transparent;

  @override
  Color get onTertiary => Colors.transparent;

  @override
  Color get surface => const Color(0xff00000c);

  @override
  Color get onSurface => const Color(0xffffffff);

  @override
  Color get background => const Color(0xff00000c);

  @override
  Color get onBackground => const Color(0xffffffff);

  @override
  Color get error => const Color(0xffFF0000);

  @override
  Color get onError => const Color(0xffffffff);

  @override
  Color get disabled => const Color(0xffffffff).withValues(alpha: 0.5);

  @override
  Color get disabledTextColor => const Color(0xffffffff);

  @override
  Color get borderColor => const Color(0xffffffff).withValues(alpha: 0.5);

  @override
  Color get defaultTextColor => const Color(0xffffffff);
}