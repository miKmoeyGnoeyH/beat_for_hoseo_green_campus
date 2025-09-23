import 'dart:developer';

import 'package:beat_flutter/controller/location/location_controller.dart';
import 'package:beat_flutter/controller/pedometer/pedometer_controller.dart';
import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../controller/user_controller.dart';
import '../../managers/prefs/prefs_manager.dart';
import '../global/methods/custom_show_dialog.dart';
import '../global/widgets/appbars/custom_empty_appbar.dart';
import '../global/widgets/buttons/custom_wide_button.dart';
import '../global/widgets/custom_scaffold.dart';
import '../global/widgets/texts/custom_body_large.dart';
import '../global/widgets/texts/custom_headline_medium.dart';
import '../global/widgets/texts/custom_title_large.dart';

class WithdrawalScreen extends StatelessWidget {
  WithdrawalScreen({super.key});

  final LocalizationManager localizationManager = LocalizationManager();

  @override
  Widget build(BuildContext context) {
    final UserController userController = context.read<UserController>();

    return CustomScaffold(
      isScrollable: false,
      hasScrollBody: false,
      appBar: const CustomEmptyAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomHeadlineMedium(text: localizationManager.withdrawal),
            const SizedBox(height: 24),
            CustomTitleLarge(text: localizationManager.withdrawalNotes),
            const SizedBox(height: 16),
            CustomBodyLarge(
                text: '1. ${localizationManager.withdrawalNote1}'),
            // const SizedBox(height: 10),
            // CustomBodyLarge(text: context.tr('withdrawal_notes', gender: '2')),
            const SizedBox(height: 10),
            CustomBodyLarge(
                text: '2. ${localizationManager.withdrawalNote3}'),
            const SizedBox(height: 10),
            CustomBodyLarge(
                text: '3. ${localizationManager.withdrawalNote4}'),
            const SizedBox(height: 24),
            CustomWideButton(
              onTap: () async {
                final String requestUrl = DotEnvManager().withdrawal;

                try {
                  final http.Response response = await http.get(
                    Uri.parse(requestUrl),
                    headers: {
                      'Authorization': userController.state.authorization
                    },
                  );
                  if (response.statusCode == 200) {
                    if (context.mounted) {
                      customShowDialog(
                        context: context,
                        title: localizationManager.withdrawalSuccess,
                        content: localizationManager.withdrawalSuccessMessage,
                        onTap: () {
                          Get.find<PedometerController>().stopForegroundService();
                          Get.find<PedometerController>().stopBackgroundService();
                          Get.find<LocationController>().stopForegroundService();
                          Get.find<LocationController>().stopBackgroundService();

                          context.read<UserController>().add(SignOut());

                          // NavigatorKeyManager().pushNamedAndRemoveUntil(RouteNames.signIn);
                        }
                      );
                      PrefsManager().resetSavedStudentIdAndPassword();
                    }
                  } else {
                    if (context.mounted) {
                      customShowDialog(
                        context: context,
                        title: localizationManager.withdrawalFailed,
                        content: localizationManager.withdrawalFailedMessage,
                      );
                    }
                  }
                } catch (e) {
                  log(e.toString());
                  if (context.mounted) {
                    customShowDialog(
                      context: context,
                      title: localizationManager.withdrawalFailed,
                      content: localizationManager.withdrawalFailedMessage,
                    );
                  }
                }
              },
              buttonText: localizationManager.withdrawal,
              buttonColor: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }
}
