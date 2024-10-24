import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../../theme/texts/custom_texts.dart';
import 'custom_rounded_bordered_container.dart';

class CustomWideButton extends StatelessWidget {
  const CustomWideButton({
    super.key,
    required this.onTap,
    this.buttonColor,
    this.buttonText,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomRoundedBorderedContainer(
        color: buttonColor ?? context.appColors.background,
        borderColor: context.appColors.primary,
        borderWidth: 0.5,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              buttonText ?? '',
              style: CustomTexts.subtitleLarge.copyWith(
                color: textColor ?? context.appColors.onPrimary,
              ),
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
}