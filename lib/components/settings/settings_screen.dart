import 'package:beat_flutter/components/global/widgets/buttons/custom_wide_button.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_body_large.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_headline_medium.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_title_medium.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/navigator/navigator_key_manager.dart';
import 'package:beat_flutter/managers/navigator/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/user_controller.dart';
import '../global/widgets/appbars/custom_empty_appbar.dart';
import '../global/widgets/custom_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserController userBloc = context.read<UserController>();

    return CustomScaffold(
      isScrollable: false,
      appBar: const CustomEmptyAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomHeadlineMedium(text: context.tr('settings')),
            const SizedBox(height: 24),
            CustomWideButton(
              onTap: () => userBloc.add(SignOut()),
              buttonColor: context.appColors.primary,
              buttonText: context.tr('sign_out'),
            ),
            const SizedBox(height: 10),
            CustomWideButton(
              onTap: () {
                NavigatorKeyManager().pushNamed(RouteNames.withdrawal);
              },
              buttonText: context.tr('withdrawal'),
              buttonColor: Colors.redAccent,
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTitleMedium(
                  text: "oss_licenses".tr(),
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    NavigatorKeyManager().pushNamed(RouteNames.ossLicenses);
                  },
                  child: CustomBodyLarge(
                    text: "view_detail".tr(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTitleMedium(
                  text: "app_inquiry".tr(),
                ),
                const SizedBox(height: 5),
                CustomBodyLarge(
                  text: "20255720@vision.hoseo.edu".tr(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  const SettingsScreen({super.key});
}
