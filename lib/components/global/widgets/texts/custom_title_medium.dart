
import 'package:Beat/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../../../../theme/texts/custom_texts.dart';

class CustomTitleMedium extends StatelessWidget {
  const CustomTitleMedium({
    super.key,
    this.text,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: CustomTexts.titleMedium.copyWith(
        color: textColor ?? context.appColors.onBackground,
      ),
    );
  }

  final String? text;
  final Color? textColor;
}