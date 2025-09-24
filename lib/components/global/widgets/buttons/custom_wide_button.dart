import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    this.borderRadius,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomRoundedBorderedContainer(
        color: buttonColor ?? context.appColors.background,
        width: width ?? double.infinity,
        height: height ?? 56.w,
        borderColor: borderColor,
        borderWidth: borderWidth ?? 0.2,
        borderRadius: borderRadius,
        child: Center(
          child: Padding(
            padding: padding ??
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.w),
            child: autoSizeText
                ? AutoSizeText(
                    buttonText ?? '',
                    style: buttonTextStyle != null
                        ? buttonTextStyle!.copyWith(
                            color: textColor ?? context.appColors.onPrimary,
                          )
                        : CustomLargeTexts.subtitleLarge.copyWith(
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
                        : CustomLargeTexts.subtitleLarge.copyWith(
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
  final double? borderRadius;
  final double? height;
  final double? width;
}
