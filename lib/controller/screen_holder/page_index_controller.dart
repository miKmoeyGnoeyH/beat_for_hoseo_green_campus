import 'package:app_settings/app_settings.dart';
import 'package:beat_flutter/components/global/methods/custom_show_dialog.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/permission/permission_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageIndexController extends GetxController {
  final Rx<int> _selectedIndex = 1.obs;

  int get selectedIndex => _selectedIndex.value;

  set selectedIndex(int index) => _selectedIndex.value = index;

  final LocalizationManager localizationManager = LocalizationManager();

  final int homeIndex = 1;

  void setIndex(int index, BuildContext context) async {
    if (index == 0) {
      final bool isCameraPermissionGranted =
          await PermissionManager.requestCameraPermission();

      if (!isCameraPermissionGranted) {
        await customConfirmDialog(
          context: context,
          title: localizationManager.qrBEATRequiresCameraPermissionTitle,
          content: localizationManager.qrBEATRequiresCameraPermissionContent,
          onConfirmTap: () => AppSettings.openAppSettings(asAnotherTask: true),
          confirmText: localizationManager.homeGotoSettings,
          cancelText: localizationManager.homeLater,
        );
        return;
      }
    }

    selectedIndex = index;

    if (selectedIndex != homeIndex) {
      scrollController.jumpTo(0);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  final ScrollController scrollController = ScrollController();
}
