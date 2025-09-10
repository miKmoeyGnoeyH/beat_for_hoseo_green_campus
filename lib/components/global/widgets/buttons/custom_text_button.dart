
import 'package:beat_flutter/components/global/widgets/texts/custom_body_large.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
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
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(borderRadius ?? 12),
        side: BorderSide(color: borderColor, width: 0.5),
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        highlightColor: highlightColor ?? Colors.transparent,
        splashColor: splashColor ?? Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: buttonColor ?? context.appColors.primary,
            border: Border.all(color: borderColor, width: 0.5),
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
          ),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: Center(
              child: CustomBodyLarge(
                text: text,
                textColor: textColor ?? context.appColors.onPrimary,
              ),
            ),
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
}
