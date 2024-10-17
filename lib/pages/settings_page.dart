import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:BEAT/theme/texts/custom_texts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../business/user_bloc.dart';
import '../widgets/global/basic_appbar.dart';
import '../widgets/global/custom_scaffold.dart';
import '../widgets/global/rounded_bordered_container.dart';

class SettingsPage extends StatelessWidget {
  final UserBloc _userBloc = UserBloc();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isScrollable: false,
      appBar: BasicAppBar(
        iconTheme: IconThemeData(color: context.appColors.primary),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('settings'),
              style: CustomTexts.headlineSmall,
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => _userBloc.add(SignOut()),
              child: RoundedBorderedContainer(
                color: context.appColors.primary,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      context.tr('sign_out'),
                      style: CustomTexts.titleLarge
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

  SettingsPage({super.key});
}
