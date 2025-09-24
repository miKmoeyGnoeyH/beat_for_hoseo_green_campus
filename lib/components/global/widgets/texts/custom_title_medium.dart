import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../../../../theme/texts/custom_texts.dart';

class CustomTitleMedium extends StatelessWidget {
  const CustomTitleMedium(
      {super.key, this.text, this.textColor, this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: CustomTexts.titleMedium.copyWith(
        color: textColor ?? context.appColors.onBackground,
        overflow: maxLines == null ? null : TextOverflow.ellipsis,
      ),
    );
  }

  final String? text;
  final Color? textColor;
  final int? maxLines;
}
