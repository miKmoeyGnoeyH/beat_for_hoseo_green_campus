import 'package:beat_flutter/components/global/beat/gc_points.dart';
import 'package:beat_flutter/components/global/beat/neuroes.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: GestureDetector(
        onTap: () => NavigatorKeyManager().pushNamed(
          RouteNames.neuroHistory,
          arguments: userController.state.authorization,
        ),
        child: CustomRoundedBorderedContainer(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    CustomBodyLarge(
                      text: localizationManager.homeTapToCheckYourHistory,
                      textColor: context.appColors.onPrimary,
                    )
                  ],
                ),
                // const Neuroes(),
                Stack(
                  children: [
                    Container(
                      width: 80,
                      decoration: BoxDecoration(
                        // color: Colors.red,
                        borderRadius: BorderRadius.circular(100),
                        // shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xff00000c),
                            blurRadius: 55,
                            spreadRadius: -25,
                          ),
                          // BoxShadow(color: context.appColors.primary)
                        ],
                      ),
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: GreenCampusPoints(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
