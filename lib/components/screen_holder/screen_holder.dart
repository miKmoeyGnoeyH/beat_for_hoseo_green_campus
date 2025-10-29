import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:app_version_update/app_version_update.dart';
import 'package:beat_flutter/components/global/methods/custom_show_dialog.dart';
import 'package:beat_flutter/components/my_page/my_page.dart';
import 'package:beat_flutter/controller/home/controllers/quest_list_controller.dart';
import 'package:beat_flutter/controller/activity_service_controller.dart';
import 'package:beat_flutter/controller/my_page/my_page_controller.dart';
import 'package:beat_flutter/controller/screen_holder/page_index_controller.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/navigator/navigator_key_manager.dart';
import 'package:beat_flutter/managers/navigator/routes.dart';
import 'package:beat_flutter/managers/permission/permission_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/home/controllers/survey_list_controller.dart';
import '../../controller/home/events/data_events.dart';
import '../../controller/user_controller.dart';
import '../home/home_screen.dart';
import '../qr/qr_screen.dart';
import 'widgets/home_appbar.dart';
import 'widgets/home_bottom_navigation_bar.dart';

class ScreenHolder extends StatefulWidget {
  const ScreenHolder({super.key});

  @override
  State<ScreenHolder> createState() => _ScreenHolderState();
}

class _ScreenHolderState extends State<ScreenHolder> {
  final LocalizationManager localizationManager = LocalizationManager();

  final PageIndexController pageIndexController =
      Get.find<PageIndexController>();

  @override
  void initState() {
    showDialogIfPermissionDenied();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showDialogIfPermissionDenied() async {
    final bool isLocationPermissionGranted =
        await PermissionManager.requestLocationPermission();
    final bool isActivityPermissionGranted =
        await PermissionManager.requestActivityPermission();

    if (!isLocationPermissionGranted) {
      await customConfirmDialog(
        context: context,
        title: localizationManager.homeBEATRequiresLocationPermissionTitle,
        content: localizationManager.homeBEATRequiresLocationPermissionContent,
        onConfirmTap: () => AppSettings.openAppSettings(asAnotherTask: true),
        confirmText: localizationManager.homeGotoSettings,
        cancelText: localizationManager.homeLater,
      );
    }
    if (!isActivityPermissionGranted) {
      await customConfirmDialog(
        context: context,
        title: localizationManager.homeBEATRequiresActivityPermissionTitle,
        content: localizationManager.homeBEATRequiresActivityPermissionContent,
        onConfirmTap: () => AppSettings.openAppSettings(asAnotherTask: true),
        confirmText: localizationManager.homeGotoSettings,
        cancelText: localizationManager.homeLater,
      );
    }

    await PermissionManager.updateLocationAndActivityPemission();
    Get.find<ActivityServiceController>().startService();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> onPullDown() async {
      final UserController userController = context.read<UserController>();

      userController.add(GetMyNeuro());
      Get.find<ActivityServiceController>().getWalkHistory();
      context.read<QuestListController>().add(DataListRequest());
      context.read<SurveyListController>().add(DataListRequest());
      await PermissionManager.updateLocationAndActivityPemission();

      return Future.delayed(const Duration(seconds: 0));
    }

    return Scaffold(
      body: Container(
        color: context.appColors.surface,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Obx(() {
            return NestedScrollView(
              controller: pageIndexController.scrollController,
              physics: !(pageIndexController.selectedIndex ==
                      pageIndexController.qrIndex)
                  ? const AlwaysScrollableScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) => const [
                HomeAppbar(),
              ],
              body: RefreshIndicator(
                  color: context.appColors.primary,
                  onRefresh: onPullDown,
                  notificationPredicate: (_) =>
                      pageIndexController.selectedIndex ==
                      pageIndexController.homeIndex,
                  child: _screens[pageIndexController.selectedIndex]),
            );
          }),
        ),
      ),
      bottomNavigationBar: Obx(() {
        return Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: context.appColors.borderColor,
                width: 0.1,
              ),
            ),
          ),
          child: HomeBottomNavigationBar(
            onTap: pageIndexController.setIndex,
            selectedIndex: pageIndexController.selectedIndex,
          ),
        );
      }),
    );
  }

  final List<Widget> _screens = [
    const QrScreen(),
    const HomeScreen(),
    MyPage(),
    // const VoteScreen()
  ];

  Future<void> _openStore({
    required String iosHttpsUrl,
    required String androidPkgId,
  }) async {
    if (Platform.isIOS) {
      final itms = Uri.parse(iosHttpsUrl.replaceFirst('https://', 'itms-apps://'));
      if (!await launchUrl(itms, mode: LaunchMode.externalApplication)) {
        await launchUrl(Uri.parse(iosHttpsUrl), mode: LaunchMode.externalApplication);
      }
    } else {
      final market = Uri.parse('market://details?id=$androidPkgId');
      if (!await launchUrl(market, mode: LaunchMode.externalApplication)) {
        final web = Uri.parse('https://play.google.com/store/apps/details?id=$androidPkgId');
        await launchUrl(web, mode: LaunchMode.externalApplication);
      }
    }
  }

  Future<void> checkUpdate() async {
    try {
      final data = await AppVersionUpdate.checkForUpdates(
        appleId: DotEnvManager().appstoreId,
        playStoreId: DotEnvManager().googleplayId,
      );
      if (!mounted) return;

      if (data.canUpdate == true) {
        FlutterNativeSplash.remove();
        await customConfirmDialog(
          context: context,
          title: localizationManager.generalUpdateAvailable,
          content: localizationManager.generalUpdateAvailableContent,
          onConfirmTap: () async {
            Navigator.of(context, rootNavigator: true).pop();
            await _openStore(
              iosHttpsUrl: data.storeUrl!,
              androidPkgId: DotEnvManager().googleplayId,
            );
          },
          onCancelTap: () {
            Navigator.of(context, rootNavigator: true).pop();
            if (mounted) NavigatorKeyManager().pushNamedAndRemoveUntil(RouteNames.signIn);
          },
        );
      } else {
        NavigatorKeyManager().pushNamedAndRemoveUntil(RouteNames.signIn);
      }
    } catch (e) {
      if (!mounted) return;
      NavigatorKeyManager().pushNamedAndRemoveUntil(RouteNames.signIn);
    }
  }
}
