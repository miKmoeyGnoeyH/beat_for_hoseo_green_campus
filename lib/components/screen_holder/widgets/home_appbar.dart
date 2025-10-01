
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../controller/user_controller.dart';
import '../../../data/models/user_model.dart';
import '../../../theme/texts/custom_texts.dart';
import '../../global/beat/beat_logo_small.dart';
import '../../global/widgets/appbars/custom_appbar.dart';
import '../../global/widgets/texts/custom_body_large.dart';
import '../../home/widgets/home_leaderboard_button.dart';
import '../../home/widgets/home_notifications_button.dart';
import '../../home/widgets/home_settings_button.dart';

class HomeAppbar extends StatelessWidget {
  const HomeAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BeatLogoSmall(),
          SizedBox(width: 12.w),
          BlocBuilder<UserController, User>(
            builder: (context, state) => CustomBodyLarge(
              text: state is !Member ? '' : state.nickname,
              // text: "BEAT: Event and Activity",
            ),
            // builder: (context, state) => Text(
            //   state is !Member ? '' : state.nickname, style: context.textTheme.bodyLarge,
            // ),
          ),
        ],
      ),
      textStyle: CustomLargeTexts.bodyMedium,
      actions: const [
        HomeLeaderboardButton(),
        // HomeInformationButton(),
        HomeNotificationsButton(),
        HomeSettingsButton(),
      ],
      pinned: true,
    );
  }
}
