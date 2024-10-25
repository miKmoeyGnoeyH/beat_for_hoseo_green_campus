import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:BEAT/managers/navigator/navigator_key_manager.dart';
import 'package:BEAT/theme/texts/custom_texts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../controller/user_bloc.dart';
import '../global/widgets/custom_appbar.dart';
import '../global/widgets/custom_rounded_bordered_container.dart';
import '../global/widgets/custom_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  final UserBloc _userBloc = UserBloc();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isScrollable: false,
      appBar: CustomAppBar(
        hasBorder: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: GestureDetector(
            onTap: () => NavigatorKeyManager().pop(),
            child: Icon(
              Icons.arrow_back_ios,
              color: context.appColors.primary,
              size: 24,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('settings'),
              style: CustomTexts.headlineSmall.copyWith(
                color: context.appColors.onBackground,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => _userBloc.add(SignOut()),
              child: CustomRoundedBorderedContainer(
                color: context.appColors.primary,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      context.tr('sign_out'),
                      style: CustomTexts.subtitleLarge
                          .copyWith(color: context.appColors.onPrimary),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SettingsScreen({super.key});
}
