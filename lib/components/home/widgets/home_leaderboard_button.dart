import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

class HomeLeaderboardButton extends StatelessWidget {
  const HomeLeaderboardButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.leaderboard_outlined,
        color: context.appColors.onSurface,
        size: 24,
      ),
      onPressed: () {},
    );
  }
}