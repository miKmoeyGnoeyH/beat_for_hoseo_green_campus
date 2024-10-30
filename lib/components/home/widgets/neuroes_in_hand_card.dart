import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../controller/user_bloc.dart';
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
    return CustomRoundedBorderedContainer(
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
              ],
            ),
            Image.asset('assets/images/beat_coin_pile.png', width: 80,),
          ],
        ),
      ),
    );
  }
}