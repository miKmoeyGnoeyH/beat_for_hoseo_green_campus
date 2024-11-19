import 'package:Beat/components/global/widgets/buttons/custom_wide_button.dart';
import 'package:Beat/components/global/widgets/texts/custom_headline_medium.dart';
import 'package:Beat/extensions/buildcontext_extension.dart';
import 'package:Beat/managers/navigator/navigator_key_manager.dart';
import 'package:Beat/managers/navigator/routes.dart';
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
          ],
        ),
      ),
    );
  }

  SettingsScreen({super.key});
}
