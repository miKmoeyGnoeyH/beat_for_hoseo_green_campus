import 'package:beat_flutter/components/global/beat/gc_points.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../controller/user_controller.dart';
import '../../../data/models/user_model.dart';
import '../../../managers/navigator/navigator_key_manager.dart';
import '../../../managers/navigator/routes.dart';
import '../../global/widgets/custom_rounded_bordered_container.dart';
import '../../global/widgets/texts/custom_body_large.dart';
import '../../global/widgets/texts/custom_headline_large.dart';
import '../../global/widgets/texts/custom_subtitle_large.dart';

class PointsInHandCard extends StatelessWidget {
  PointsInHandCard({
    super.key,
  });

  final LocalizationManager localizationManager = LocalizationManager();

  @override
  Widget build(BuildContext context) {
    final UserController userController = context.read<UserController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
      child: GestureDetector(
        onTap: () => NavigatorKeyManager().pushNamed(
          RouteNames.neuroHistory,
          arguments: userController.state.authorization,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: context.appColors.primary,
          ),
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/gc_points.png'),
                // fit: BoxFit.contain,
                scale: 10.0,
                alignment: Alignment.centerRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomSubtitleLarge(
                  text: localizationManager.homePointsInHand,
                  textColor: context.appColors.onPrimary,
                ),
                BlocBuilder<UserController, User>(
                  builder: (context, state) => CustomHeadlineLarge(
                    text: state is Member
                        ? NumberFormat("###,###,###,###")
                            .format(int.parse(state.neuroesInHand))
                        : '',
                    textColor: context.appColors.onPrimary,
                  ),
                ),
                SizedBox(
                  child: CustomBodyLarge(
                    text: localizationManager
                        .homeTapToCheckYourHistory,
                    textColor: context.appColors.onPrimary,
                    maxLines: 2,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
