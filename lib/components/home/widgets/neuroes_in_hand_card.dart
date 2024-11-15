
import 'package:Beat/extensions/buildcontext_extension.dart';
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

class NeuroesInHandCard extends StatelessWidget {
  const NeuroesInHandCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final UserController userController = context.read<UserController>();

    return GestureDetector(
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
                    text: context.tr('neuroes_in_hand'),
                    textColor: context.appColors.onPrimary,
                  ),
                  BlocBuilder<UserController, User>(
                    builder: (context, state) => CustomHeadlineLarge(
                      text: state is Member ? state.neuroesInHand : '',
                      textColor: context.appColors.onPrimary,
                    ),
                  ),
                  CustomBodyLarge(
                    text: context.tr('tap_to_check_your_history'),
                    textColor: context.appColors.onPrimary,
                  )
                ],
              ),
              const ALotOfNeuroes(),
            ],
          ),
        ),
      ),
    );
  }
}

class ALotOfNeuroes extends StatelessWidget {
  const ALotOfNeuroes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/neuroes_pile.png',
      width: 80,
    );
  }
}
