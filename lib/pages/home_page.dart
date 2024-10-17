import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:BEAT/theme/texts/custom_texts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../business/user_bloc.dart';
import '../data/models/user_model.dart';
import '../widgets/global/basic_appbar.dart';
import '../widgets/global/custom_scaffold.dart';
import '../widgets/global/rounded_bordered_container.dart';
import 'routes/routes.dart';

class HomePage extends StatelessWidget {
  final UserBloc _userBloc = UserBloc();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: BasicAppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/beat_icon.png',
              width: 24,
              height: 24,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 12),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${user.nickname}님 ',
                    style: CustomTexts.bodyLarge,
                  ),
                  TextSpan(
                    text: '${user.neuroesInHand} neuro',
                    style: CustomTexts.bodyLarge
                        .copyWith(color: context.appColors.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
        textStyle: CustomTexts.bodyMedium,
        actions: [
          IconButton(
            icon: Icon(
              Icons.leaderboard_outlined,
              color: context.appColors.onSurface,
              size: 24,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              size: 24,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              size: 24,
            ),
            onPressed: () => Navigator.pushNamed(context, Routes.settings),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32),
        child: Column(
          children: [
            RoundedBorderedContainer(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr('neuroes_in_hand'),
                          style: CustomTexts.subtitleLarge
                              .copyWith(color: context.appColors.onPrimary),
                        ),
                        Text(
                          user.neuroesInHand,
                          style: CustomTexts.headlineLarge
                              .copyWith(color: context.appColors.onPrimary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  User get user => _userBloc.state;

  HomePage({super.key});
}
