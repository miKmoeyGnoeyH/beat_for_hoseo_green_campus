import 'package:beat_flutter/extensions/buildcontext_extension.dart';
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
    this.borderWidth,
    this.borderColor,
    this.padding,
    this.autoSizeText = true,
    this.buttonTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomRoundedBorderedContainer(
        color: buttonColor ?? context.appColors.background,
        height: 56,
        borderColor: borderColor,
        borderWidth: borderWidth ?? 0.2,
        child: Center(
          child: Padding(
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            child: autoSizeText
                ? AutoSizeText(
                    buttonText ?? '',
                    style: buttonTextStyle != null
                        ? buttonTextStyle!.copyWith(
                            color: textColor ?? context.appColors.onPrimary,
                          )
                        : CustomTexts.subtitleLarge.copyWith(
                            color: textColor ?? context.appColors.onPrimary,
                          ),
                    maxLines: maxLines ?? 1,
                  )
                : Text(
                    buttonText ?? '',
                    style: buttonTextStyle != null
                        ? buttonTextStyle!.copyWith(
                            color: textColor ?? context.appColors.onPrimary,
                          )
                        : CustomTexts.subtitleLarge.copyWith(
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
  final double? borderWidth;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final bool autoSizeText;
  final TextStyle? buttonTextStyle;
}
