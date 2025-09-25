import 'package:beat_flutter/components/global/widgets/buttons/custom_wide_button.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_body_large.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_headline_medium.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_title_medium.dart';
import 'package:beat_flutter/controller/activity_service_controller.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/navigator/navigator_key_manager.dart';
import 'package:beat_flutter/managers/navigator/routes.dart';
import 'package:beat_flutter/managers/package_info/package_info_manager.dart';
import 'package:beat_flutter/managers/prefs/prefs_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomHeadlineMedium(text: localizationManager.settingsAppbarTitle),
            SizedBox(height: 24.w),
            CustomWideButton(
              height: 60.w,
              autoSizeText: true,
              borderRadius: 10,
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 10.w,
              ),
              onTap: () async {
                await Get.find<ActivityServiceController>()
                    .stopForegroundService();
                await Get.find<ActivityServiceController>()
                    .stopBackgroundService();

                // PrefsManager().withDrawal();
                PrefsManager().clear();
                userBloc.add(SignOut());
              },
              buttonColor: context.appColors.primary,
              buttonText: localizationManager.settingsSignOut,
            ),
            SizedBox(height: 10.w),
            CustomWideButton(
              height: 60.w,
              autoSizeText: true,
              borderRadius: 10,
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 10.w,
              ),
              onTap: () {
                NavigatorKeyManager().pushNamed(RouteNames.withdrawal);
              },
              buttonText: localizationManager.settingsWithdrawal,
              buttonColor: Colors.redAccent,
            ),
            SizedBox(height: 30.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTitleMedium(
                  text: localizationManager.settingsOSSLicenses,
                ),
                SizedBox(height: 5.w),
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
            SizedBox(height: 20.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTitleMedium(
                  text: localizationManager.settingsVersion,
                ),
                SizedBox(height: 5.w),
                CustomBodyLarge(
                  text:
                  "${PackageInfoManager.instance.version}(${PackageInfoManager.instance.buildNumber})",
                ),
              ],
            ),
            SizedBox(height: 20.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTitleMedium(
                  text: localizationManager.settingsAppInquiry,
                ),
                SizedBox(height: 5.w),
                CustomBodyLarge(
                  text: "${localizationManager.settingsEmail}: ${localizationManager.settingsEmailAddress}",
                ),
                CustomBodyLarge(
                  text: "${localizationManager.settingsPhone}: ${localizationManager.settingsPhoneNumber}",
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
