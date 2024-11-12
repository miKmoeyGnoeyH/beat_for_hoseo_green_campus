import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:BEAT/managers/navigator/navigator_key_manager.dart';
import 'package:flutter/material.dart';

import '../../../managers/navigator/routes.dart';

class HomeLeaderboardButton extends StatelessWidget {
  const HomeLeaderboardButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: const VisualDensity(horizontal: -4),
      icon: Icon(
        Icons.leaderboard_outlined,
        color: context.appColors.onSurface,
        size: 24,
      ),
      onPressed: () {
        NavigatorKeyManager().pushNamed(RouteNames.ranking);
      },
    );
  }
}