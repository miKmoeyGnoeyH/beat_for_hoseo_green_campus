import 'package:beat_flutter/controller/user_controller.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../managers/navigator/navigator_key_manager.dart';
import '../../../managers/navigator/routes.dart';

class HomeLeaderboardButton extends StatelessWidget {
  const HomeLeaderboardButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final UserController userController = context.read<UserController>();

    return IconButton(
      visualDensity: const VisualDensity(horizontal: -4),
      icon: Icon(
        Icons.leaderboard_outlined,
        color: context.appColors.onSurface,
        size: 24.w,
      ),
      onPressed: () {
        NavigatorKeyManager().pushNamed(
          RouteNames.ranking,
          arguments: userController.state.authorization,
        );
      },
    );
  }
}
