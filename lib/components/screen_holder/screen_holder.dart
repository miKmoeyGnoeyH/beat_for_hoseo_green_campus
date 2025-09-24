import 'package:app_settings/app_settings.dart';
import 'package:beat_flutter/components/global/methods/custom_show_dialog.dart';
import 'package:beat_flutter/components/my_page/my_page.dart';
import 'package:beat_flutter/controller/home/controllers/quest_list_controller.dart';
import 'package:beat_flutter/controller/location/location_controller.dart';
import 'package:beat_flutter/controller/pedometer/pedometer_controller.dart';
import 'package:beat_flutter/controller/screen_holder/page_index_controller.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/permission/permission_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

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

class _ScreenHolderState extends State<ScreenHolder>
    with WidgetsBindingObserver {
  final LocalizationManager localizationManager = LocalizationManager();

  final PageIndexController pageIndexController =
      Get.find<PageIndexController>();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    debugPrint('didChangeAppLifecycleState: $state');
    switch (state) {
      case AppLifecycleState.resumed:
        await Get.find<PedometerController>().stopBackgroundService();
        await Get.find<LocationController>().stopBackgroundService();

        Get.find<PedometerController>().startForegroundService();
        Get.find<LocationController>().startForegroundService();

        setState(() {});
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        await Get.find<PedometerController>().stopForegroundService();
        await Get.find<LocationController>().stopForegroundService();

        Get.find<PedometerController>().startBackgroundService();
        Get.find<LocationController>().startBackgroundService();
        break;
      case AppLifecycleState.detached:
      default:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    showDialogIfPermissionDenied();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void showDialogIfPermissionDenied() async {
    final bool isLocationPermissionGranted =
        await PermissionManager.requestLocationPermission();
    final bool isActivityPermissionGranted =
        await PermissionManager.requestActivityPermission();
    final bool isCameraPermissionGranted =
        await PermissionManager.requestCameraPermission();

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
    if (!isCameraPermissionGranted) {
      await customConfirmDialog(
        context: context,
        title: localizationManager.qrBEATRequiresCameraPermissionTitle,
        content: localizationManager.qrBEATRequiresCameraPermissionContent,
        onConfirmTap: () => AppSettings.openAppSettings(asAnotherTask: true),
        confirmText: localizationManager.homeGotoSettings,
        cancelText: localizationManager.homeLater,
      );
    }

    await PermissionManager.updateLocationAndActivityPemission();
    Get.find<PedometerController>().startForegroundService();
    Get.find<LocationController>().startForegroundService();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> onPullDown() async {
      final UserController userController = context.read<UserController>();
      userController.add(GetMyNeuro());
      context.read<QuestListController>().add(DataListRequest());
      context.read<SurveyListController>().add(DataListRequest());
      Get.find<PedometerController>().getWalkHitory();
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
              physics: pageIndexController.selectedIndex ==
                      pageIndexController.homeIndex
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
    HomeScreen(),
    MyPage(),
    // const VoteScreen()
  ];
}
