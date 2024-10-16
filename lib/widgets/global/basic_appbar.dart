import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

class BasicAppBar extends StatelessWidget {
  const BasicAppBar({
    this.title,
    this.textColor,
    this.textStyle,
    this.leading,
    this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: title,
      foregroundColor: context.colorScheme.onSecondary,
      backgroundColor: context.colorScheme.secondary,
      surfaceTintColor: context.colorScheme.secondary,
      leading: leading,
      actions: actions,
    );
  }

  final Widget? title;
  final Color? textColor;
  final TextStyle? textStyle;
  final Widget? leading;
  final List<Widget>? actions;
}
