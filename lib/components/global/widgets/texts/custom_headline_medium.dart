
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../../../../theme/texts/custom_texts.dart';

class CustomHeadlineMedium extends StatelessWidget {
  const CustomHeadlineMedium({
    super.key,
    this.text,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      style: CustomLargeTexts.headlineMedium.copyWith(
        color: textColor ?? context.appColors.onBackground,
      ),
    );
  }

  final String? text;
  final Color? textColor;
}