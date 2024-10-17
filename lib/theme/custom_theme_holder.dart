import 'package:BEAT/theme/colors/if_custom_colors.dart';
import 'package:flutter/material.dart';

class CustomThemeHolder extends InheritedWidget {
  const CustomThemeHolder({
    super.key,
    required super.child,
    required this.appColors,
  });

  static CustomThemeHolder of(BuildContext context) {
    final CustomThemeHolder? result =
        context.dependOnInheritedWidgetOfExactType<CustomThemeHolder>();
    assert(result != null, 'No CustomThemeHolder found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(CustomThemeHolder oldWidget) {
    return oldWidget.appColors != appColors;
  }

  final CustomColors appColors;
}
