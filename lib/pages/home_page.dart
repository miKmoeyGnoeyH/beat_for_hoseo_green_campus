import 'package:beat_flutter/business/user_bloc.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/widgets/global/rounded_bordered_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../data/models/user_model.dart';
import '../widgets/global/basic_appbar.dart';
import '../widgets/global/custom_scaffold.dart';
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
                    style: context.textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: '${user.neuroesInHand} neuro',
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: context.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        textStyle: context.textTheme.bodyMedium,
        actions: [
          IconButton(
            icon: Icon(
              Icons.leaderboard_outlined,
              color: context.colorScheme.onSurface,
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
                          style: context.textTheme.bodyLarge!.copyWith(
                            color: context.colorScheme.onPrimary,
                          ),
                        ),
                        Text(
                          user.neuroesInHand,
                          style: context.textTheme.headlineLarge!.copyWith(
                            color: context.colorScheme.onPrimary,
                          ),
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
