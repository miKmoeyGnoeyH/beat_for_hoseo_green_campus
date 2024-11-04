import 'package:flutter/material.dart';

import '../../../controller/user_bloc.dart';
import '../../../theme/texts/custom_texts.dart';
import '../../global/beat/beat_logo_small.dart';
import '../../global/widgets/appbars/custom_appbar.dart';
import '../../global/widgets/texts/custom_body_large.dart';
import 'home_leaderboard_button.dart';
import 'home_notifications_button.dart';
import 'home_settings_button.dart';

class HomeAppbar extends StatelessWidget {
  const HomeAppbar({
    super.key,
    required this.userBloc,
  });

  final UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: Row(
        children: [
          const BeatLogoSmall(),
          const SizedBox(width: 12),
          CustomBodyLarge(text: userBloc.state.nickname)
        ],
      ),
      textStyle: CustomTexts.bodyMedium,
      actions: const [
        HomeLeaderboardButton(),
        HomeNotificationsButton(),
        HomeSettingsButton(),
      ],
      pinned: true,
    );
  }
}
