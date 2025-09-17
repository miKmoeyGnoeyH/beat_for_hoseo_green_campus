import 'package:auto_size_text/auto_size_text.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_body_large.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/theme/texts/custom_texts.dart';
import 'package:flutter/material.dart';

class CustomTextButtonWrap extends StatelessWidget {
  const CustomTextButtonWrap({
    super.key,
    this.borderRadius,
    this.onTap,
    this.highlightColor,
    this.splashColor,
    this.buttonColor,
    this.borderColor = Colors.transparent,
    this.padding,
    this.text = "",
    this.textColor,
    this.autoSizeText = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        side: BorderSide(color: borderColor, width: 0.5),
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: buttonColor ?? context.appColors.primary,
            border: Border.all(color: borderColor, width: 0.5),
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
          ),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: autoSizeText
              ? AutoSizeText(
            text,
            style: CustomTexts.bodyLarge.copyWith(
              color: textColor ?? context.appColors.onPrimary,
            ),
            maxLines: maxLines,
          )
              : CustomBodyLarge(
            text: text,
            textColor: textColor ?? context.appColors.onPrimary,
          ),
        ),
      ),
    );
  }

  final double? borderRadius;
  final VoidCallback? onTap;
  final Color? highlightColor;
  final Color? splashColor;
  final Color? buttonColor;
  final Color borderColor;
  final EdgeInsets? padding;
  final String text;
  final Color? textColor;
  final bool autoSizeText;
  final int maxLines;
}
