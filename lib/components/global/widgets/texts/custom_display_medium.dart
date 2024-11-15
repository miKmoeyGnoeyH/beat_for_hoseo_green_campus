import 'package:Beat/extensions/buildcontext_extension.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../../theme/texts/custom_texts.dart';

class CustomDisplayMedium extends StatelessWidget {
  const CustomDisplayMedium({
    super.key,
    this.text,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text ?? '',
      style: CustomTexts.displayMedium
          .copyWith(color: textColor ?? context.appColors.onBackground),
    );
  }

  final String? text;
  final Color? textColor;
}