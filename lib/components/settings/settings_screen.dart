import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:BEAT/theme/texts/custom_texts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../controller/user_controller.dart';
import '../global/widgets/appbars/custom_empty_appbar.dart';
import '../global/widgets/custom_rounded_bordered_container.dart';
import '../global/widgets/custom_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  final UserController _userBloc = UserController();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isScrollable: false,
      appBar: const CustomEmptyAppBar(),
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
