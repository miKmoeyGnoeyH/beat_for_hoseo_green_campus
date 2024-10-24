import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

class CustomRoundedBorderedContainer extends StatelessWidget {
  const CustomRoundedBorderedContainer({
    this.width,
    this.height,
    this.margin,
    this.color,
    this.borderColor,
    this.borderWidth,
    this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? context.appColors.primary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor ?? context.appColors.disabled,
          width: borderWidth ?? 0.1,
        ),
      ),
      child: child,
    );
  }

  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Color? borderColor;
  final double? borderWidth;
  final Widget? child;
}
