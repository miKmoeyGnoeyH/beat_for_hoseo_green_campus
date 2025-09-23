import 'package:beat_flutter/components/global/widgets/buttons/custom_wide_button.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_body_large.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_headline_medium.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_title_medium.dart';
import 'package:beat_flutter/controller/location/location_controller.dart';
import 'package:beat_flutter/controller/pedometer/pedometer_controller.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/navigator/navigator_key_manager.dart';
import 'package:beat_flutter/managers/navigator/routes.dart';
import 'package:beat_flutter/managers/package_info/package_info_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' hide Trans;

import '../../controller/user_controller.dart';
import '../global/widgets/appbars/custom_empty_appbar.dart';
import '../global/widgets/custom_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  final LocalizationManager localizationManager = LocalizationManager();

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
            CustomHeadlineMedium(text: localizationManager.settingsAppbarTitle),
            const SizedBox(height: 24),
            CustomWideButton(
              onTap: () {
                Get.find<PedometerController>().stopForegroundService();
                Get.find<PedometerController>().stopBackgroundService();
                Get.find<LocationController>().stopForegroundService();
                Get.find<LocationController>().stopBackgroundService();
                userBloc.add(SignOut());
              },
              buttonColor: context.appColors.primary,
              buttonText: localizationManager.settingsSignOut,
            ),
            const SizedBox(height: 10),
            CustomWideButton(
              onTap: () {
                NavigatorKeyManager().pushNamed(RouteNames.withdrawal);
              },
              buttonText: localizationManager.settingsWithdrawal,
              buttonColor: Colors.redAccent,
            ),
            const SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTitleMedium(
                  text: localizationManager.settingsOSSLicenses,
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    NavigatorKeyManager().pushNamed(RouteNames.ossLicenses);
                  },
                  child: CustomBodyLarge(
                    text: localizationManager.settingsViewDetail,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTitleMedium(
                  text: localizationManager.settingsAppInquiry,
                ),
                const SizedBox(height: 5),
                CustomBodyLarge(
                  text: "${localizationManager.settingsEmail}: ${localizationManager.settingsEmailAddress}",
                ),
                CustomBodyLarge(
                  text: "${localizationManager.settingsPhone}: ${localizationManager.settingsPhoneNumber}",
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTitleMedium(
                  text: localizationManager.settingsVersion,
                ),
                const SizedBox(height: 5),
                CustomBodyLarge(
                  text:
                      "${PackageInfoManager.instance.version}(${PackageInfoManager.instance.buildNumber})",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SettingsScreen({super.key});
}
