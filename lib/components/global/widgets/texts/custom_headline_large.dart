import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../../../../theme/texts/custom_texts.dart';

class CustomHeadlineLarge extends StatelessWidget {
  const CustomHeadlineLarge({
    super.key,
    this.text,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      style: CustomTexts.headlineLarge.copyWith(
        color: textColor ?? context.appColors.onBackground,
      ),
    );
  }

  final String? text;
  final Color? textColor;
}