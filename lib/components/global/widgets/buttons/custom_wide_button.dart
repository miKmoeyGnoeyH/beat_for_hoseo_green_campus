import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../../theme/texts/custom_texts.dart';
import '../custom_rounded_bordered_container.dart';

class CustomWideButton extends StatelessWidget {
  const CustomWideButton({
    super.key,
    required this.onTap,
    this.buttonColor,
    this.buttonText,
    this.textColor,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomRoundedBorderedContainer(
        color: buttonColor ?? context.appColors.background,
        height: 56,
        borderWidth: 0.5,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            child: AutoSizeText(
              buttonText ?? '',
              style: CustomTexts.subtitleLarge.copyWith(
                color: textColor ?? context.appColors.onPrimary,
              ),
              maxLines: maxLines ?? 1,
            ),
          ),
        ),
      ),
    );
  }

  final Function()? onTap;
  final Color? buttonColor;
  final String? buttonText;
  final Color? textColor;
  final int? maxLines;
}
