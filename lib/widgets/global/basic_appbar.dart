import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

class BasicAppBar extends StatelessWidget {
  const BasicAppBar({
    required this.title,
    this.textColor,
    this.leading,
    this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(
        title,
        style: textColor != null
            ? context.textTheme.titleMedium!.copyWith(color: textColor)
            : context.textTheme.titleMedium,
      ),
      foregroundColor: context.colorScheme.onPrimary,
      backgroundColor: context.colorScheme.primary,
      surfaceTintColor: context.colorScheme.primary,
      actions: [
        // TODO: Replace with your icon
        IconButton(
          icon: const Icon(
            Icons.leaderboard_outlined,
            size: 24,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(
            Icons.notifications_none_rounded,
            size: 24,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  final String title;
  final Color? textColor;
  final Widget? leading;
  final List<Widget>? actions;
}
