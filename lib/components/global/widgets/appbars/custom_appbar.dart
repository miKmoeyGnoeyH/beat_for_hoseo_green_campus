import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    this.centerTitle = true,
    this.title,
    this.textColor,
    this.textStyle,
    this.leading,
    this.leadingWidth,
    this.actions,
    this.iconTheme,
    this.hasBorder = true,
    this.pinned = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: title,
      foregroundColor: context.appColors.onBackground,
      backgroundColor: context.appColors.background,
      surfaceTintColor: context.appColors.background,
      leading: leading,
      leadingWidth: leadingWidth,
      actions: actions,
      iconTheme: iconTheme,
      shape: hasBorder
          ? Border(
              bottom: BorderSide(
                color: context.appColors.onSurface.withOpacity(0.2),
                width: 0.5,
              ),
            )
          : null,
      pinned: pinned,
    );
  }

  final bool centerTitle;
  final Widget? title;
  final Color? textColor;
  final TextStyle? textStyle;
  final Widget? leading;
  final double? leadingWidth;
  final List<Widget>? actions;
  final IconThemeData? iconTheme;
  final bool hasBorder;
  final bool pinned;
}
