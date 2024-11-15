
import 'package:Beat/extensions/buildcontext_extension.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../../theme/texts/custom_texts.dart';

class CustomDisplaySmall extends StatelessWidget {
  const CustomDisplaySmall({
    super.key,
    this.text,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text ?? '',
      style: CustomTexts.displaySmall
          .copyWith(color: textColor ?? context.appColors.onBackground),
    );
  }

  final String? text;
  final Color? textColor;
}