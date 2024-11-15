import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../../../../theme/texts/custom_texts.dart';

class CustomTitleLarge extends StatelessWidget {
  const CustomTitleLarge({
    super.key,
    this.text,
    this.textColor,
    this.maxLines
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      maxLines: maxLines,
      // overflow: TextOverflow.ellipsis,
      style: CustomTexts.titleLarge.copyWith(
        color: textColor ?? context.appColors.onBackground,
      ),
    );
  }

  final String? text;
  final Color? textColor;
  final int? maxLines;
}