
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

class CustomRoundedBorderedContainer extends StatelessWidget {
  const CustomRoundedBorderedContainer({
    this.width,
    this.height,
    this.margin,
    this.color,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.child,
    this.borderTop = false,
    this.borderBottom = false,
    this.borderLeft = false,
    this.borderRight = false,
    this.radiusTopLeft = false,
    this.radiusTopRight = false,
    this.radiusBottomLeft = false,
    this.radiusBottomRight = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? context.appColors.primary,
        borderRadius: radiusTopLeft || radiusTopRight || radiusBottomLeft || radiusBottomRight ? BorderRadius.only(
          topLeft: radiusTopLeft ? Radius.circular(borderRadius ?? 16) : Radius.zero,
          topRight: radiusTopRight ? Radius.circular(borderRadius ?? 16) : Radius.zero,
          bottomLeft: radiusBottomLeft ? Radius.circular(borderRadius ?? 16) : Radius.zero,
          bottomRight: radiusBottomRight ? Radius.circular(borderRadius ?? 16) : Radius.zero,
        ) : BorderRadius.circular(borderRadius ?? 16),
        border: borderTop || borderBottom || borderLeft || borderRight ? Border(
          top: borderTop ? BorderSide(color: borderColor ?? context.appColors.borderColor, width: borderWidth ?? 0.1) : BorderSide.none,
          bottom: borderBottom ? BorderSide(color: borderColor ?? context.appColors.borderColor, width: borderWidth ?? 0.1) : BorderSide.none,
          left: borderLeft ? BorderSide(color: borderColor ?? context.appColors.borderColor, width: borderWidth ?? 0.1) : BorderSide.none,
          right: borderRight ? BorderSide(color: borderColor ?? context.appColors.borderColor, width: borderWidth ?? 0.1) : BorderSide.none,
        ) :
        Border.all(
          color: borderColor ?? context.appColors.borderColor,
          width: borderWidth ?? 0.1,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: child,
    );
  }

  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? borderRadius;
  final Color? borderColor;
  final double? borderWidth;
  final Widget? child;
  final bool borderTop;
  final bool borderBottom;
  final bool borderLeft;
  final bool borderRight;
  final bool radiusTopLeft;
  final bool radiusTopRight;
  final bool radiusBottomLeft;
  final bool radiusBottomRight;
}
