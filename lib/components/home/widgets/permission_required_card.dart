import 'package:app_settings/app_settings.dart';
import 'package:beat_flutter/components/global/widgets/buttons/custom_text_button_wrap.dart';
import 'package:beat_flutter/components/global/widgets/custom_rounded_bordered_container.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_body_large.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_subtitle_large.dart';
import 'package:beat_flutter/controller/pedometer/pedometer_controller.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/permission/permission_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PermissionRequiredCard extends StatefulWidget {
  PermissionRequiredCard({super.key});

  @override
  State<PermissionRequiredCard> createState() => _PermissionRequiredCardState();
}

class _PermissionRequiredCardState extends State<PermissionRequiredCard>
    with WidgetsBindingObserver {
  final LocalizationManager localizationManager = LocalizationManager();
  final PedometerController pedometerController =
      Get.find<PedometerController>();

  late Future<void> _permissionFuture;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        setState(() {
          _permissionFuture = Future.delayed(
            const Duration(seconds: 0),
            () => PermissionManager.isLocationPermissionGrantedStatic,
          );
        });
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      default:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _permissionFuture = Future.delayed(
      const Duration(seconds: 0),
      () => PermissionManager.isLocationPermissionGrantedStatic,
    );
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget _buildPermissionErrorCard(String title, String content) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: CustomRoundedBorderedContainer(
        width: double.infinity,
        color: context.appColors.error,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomSubtitleLarge(
                text: localizationManager.homePauseStepCount,
                textColor: context.appColors.onPrimary,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.w),
              CustomBodyLarge(
                text: title,
                textColor: context.appColors.onPrimary,
                textAlign: TextAlign.center,
              ),
              CustomBodyLarge(
                text: content,
                textColor: context.appColors.onPrimary,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.w),
              CustomTextButtonWrap(
                buttonColor: context.appColors.errorButton,
                text: localizationManager.homeGotoSettings,
                onTap: AppSettings.openAppSettings,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: CustomRoundedBorderedContainer(
        width: double.infinity,
        color: context.appColors.error,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomSubtitleLarge(
                text: localizationManager.homePauseStepCount,
                textColor: context.appColors.onPrimary,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.w),
              CustomBodyLarge(
                text: text,
                textColor: context.appColors.onPrimary,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _permissionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox.shrink();
        }

        Widget child = const SizedBox.shrink();

        // 위치/활동 권한 부족
        if ((PermissionManager.isLocationPermissionGrantedStatic != null &&
                !PermissionManager.isLocationPermissionGrantedStatic!) ||
            (PermissionManager.isActivityPermissionGrantedStatic != null &&
                !PermissionManager.isActivityPermissionGrantedStatic!)) {
          child = _buildPermissionErrorCard(
            localizationManager
                .homeBEATRequiresLocationAndActivityPermissionTitle,
            localizationManager
                .homePleaseChangeTheLocationAndActivityPermissions,
          );
        } else {
          // Obx로 동적 조건 처리
          return Obx(() {
            Widget inner = const SizedBox.shrink();
            if (!pedometerController.isInValidArea) {
              inner = _buildErrorCard(localizationManager.homeNotInValidArea);
            } else if (pedometerController.isHoliday) {
              inner = _buildErrorCard(localizationManager.homeNotEventDuration);
            } else if (pedometerController.isReachedMaxStepCount) {
              inner = _buildErrorCard(
                  localizationManager.homeReachedTodaysMaxStepCount);
            }

            return AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: inner,
            );
          });
        }

        return AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Column(
            children: [
              child,
              SizedBox(height: child is SizedBox ? 0 : 16.w),
            ],
          ),
        );
      },
    );
  }
}
