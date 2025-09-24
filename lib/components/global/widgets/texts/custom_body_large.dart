import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../../../../theme/texts/custom_texts.dart';

class CustomBodyLarge extends StatelessWidget {
  const CustomBodyLarge({
    super.key,
    this.text,
    this.textColor,
    this.maxLines,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      style: CustomLargeTexts.bodyLarge.copyWith(
        color: textColor ?? context.appColors.onBackground,
      ),
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }

  final String? text;
  final Color? textColor;
  final int? maxLines;
  final TextAlign? textAlign;
}
