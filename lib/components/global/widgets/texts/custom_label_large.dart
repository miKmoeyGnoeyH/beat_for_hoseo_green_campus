import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../../../../theme/texts/custom_texts.dart';

class CustomLabelLarge extends StatelessWidget {
  const CustomLabelLarge({
    super.key,
    this.text,
    this.textColor,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      style: CustomLargeTexts.labelLarge.copyWith(
        color: textColor ?? context.appColors.onBackground.withValues(alpha: 0.5),
      ),
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
    );
  }

  final String? text;
  final Color? textColor;
  final int? maxLines;
}