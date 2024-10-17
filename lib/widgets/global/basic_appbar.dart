import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

class BasicAppBar extends StatelessWidget {
  const BasicAppBar({
    this.title,
    this.textColor,
    this.textStyle,
    this.leading,
    this.actions,
    this.iconTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: title,
      foregroundColor: context.appColors.onBackground,
      backgroundColor: context.appColors.background,
      surfaceTintColor: context.appColors.surface,
      leading: leading,
      actions: actions,
      iconTheme: iconTheme,
      shape: Border(
        bottom: BorderSide(
          color: context.appColors.onSurface.withOpacity(0.2),
          width: 0.5,
        ),
      ),
    );
  }

  final Widget? title;
  final Color? textColor;
  final TextStyle? textStyle;
  final Widget? leading;
  final List<Widget>? actions;
  final IconThemeData? iconTheme;
}
