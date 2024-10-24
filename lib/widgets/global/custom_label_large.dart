import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../../theme/texts/custom_texts.dart';

class CustomLabelLarge extends StatelessWidget {
  const CustomLabelLarge({
    super.key,
    this.labelText,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      labelText ?? '',
      style: CustomTexts.labelLarge.copyWith(
        color: textColor ?? context.appColors.onBackground.withOpacity(0.5),
      ),
    );
  }

  final String? labelText;
  final Color? textColor;
}