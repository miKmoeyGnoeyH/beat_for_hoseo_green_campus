import 'package:Beat/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../../../../theme/texts/custom_texts.dart';

class CustomSubtitleLarge extends StatelessWidget {
  const CustomSubtitleLarge({
    super.key,
    this.text,
    this.textColor,
    this.maxLines
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      style: CustomTexts.subtitleLarge.copyWith(
        color: textColor ?? context.appColors.onBackground,
      ),
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
    );
  }

  final String? text;
  final Color? textColor;
  final int? maxLines;
}