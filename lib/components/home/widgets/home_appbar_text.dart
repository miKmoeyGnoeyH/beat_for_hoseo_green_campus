import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../controller/user_bloc.dart';
import '../../../theme/texts/custom_texts.dart';

class HomeAppbarText extends StatelessWidget {
  const HomeAppbarText({
    super.key,
    required this.userBloc,
  });

  final UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text:
            context.tr('indicate_nickname', args: [userBloc.state.nickname]),
            style: CustomTexts.bodyLarge,
          ),
          TextSpan(
            text: '${userBloc.state.neuroesInHand} Neuro',
            style: CustomTexts.bodyLarge
                .copyWith(color: context.appColors.primary),
          ),
        ],
      ),
    );
  }
}