import 'package:flutter/material.dart';

import '../theme/colors/if_custom_colors.dart';
import '../theme/custom_theme_holder.dart';

extension BuildcontextExtension on BuildContext {
  CustomColors get appColors => CustomThemeHolder.of(this).appColors;

  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
}