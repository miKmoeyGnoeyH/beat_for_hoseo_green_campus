import 'package:BEAT/components/global/widgets/texts/custom_body_large.dart';
import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:BEAT/managers/navigator/navigator_key_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../controller/user_bloc.dart';
import '../../../managers/navigator/routes.dart';
import '../../global/widgets/custom_rounded_bordered_container.dart';
import '../../global/widgets/texts/custom_headline_large.dart';
import '../../global/widgets/texts/custom_subtitle_large.dart';

class NeuroesInHandCard extends StatelessWidget {
  const NeuroesInHandCard({
    super.key,
    required this.userBloc,
  });

  final UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    userBloc.add(GetMyNeuro());
    return GestureDetector(
      onTap: () => NavigatorKeyManager().pushNamed(RouteNames.neuroHistory, arguments: userBloc.state.authorization),
      child: CustomRoundedBorderedContainer(
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                  CustomHeadlineLarge(
                    text: userBloc.state.neuroesInHand,
                    textColor: context.appColors.onPrimary,
                  ),
                  CustomBodyLarge(
                    text: context.tr('tap_to_check_your_history'),
                    textColor: context.appColors.onPrimary,
                  )
                ],
              ),
              Image.asset('assets/images/neuroes_pile.png', width: 80,),
            ],
          ),
        ),
      ),
    );
  }
}