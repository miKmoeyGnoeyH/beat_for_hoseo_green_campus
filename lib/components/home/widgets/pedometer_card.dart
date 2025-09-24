import 'package:app_settings/app_settings.dart';
import 'package:beat_flutter/components/global/widgets/buttons/custom_text_button_wrap.dart';
import 'package:beat_flutter/components/global/widgets/custom_rounded_bordered_container.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_body_large.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_headline_large.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_subtitle_large.dart';
import 'package:beat_flutter/controller/pedometer/pedometer_controller.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/permission/permission_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class PedometerCard extends StatefulWidget {
  const PedometerCard({super.key});

  @override
  State<PedometerCard> createState() => _PedometerCardState();
}

class _PedometerCardState extends State<PedometerCard> {
  final LocalizationManager localizationManager = LocalizationManager();

  final PedometerController pedometerController =
      Get.find<PedometerController>();

  @override
  void initState() {
    PermissionManager.ensureLocationAndActivityPermissionInitialized();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.w),
      child: Stack(
        children: [
          CustomRoundedBorderedContainer(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.w),
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    top: 10.w,
                    child: SvgPicture.asset(
                      "assets/svg/footstep.svg",
                      width: 80.w,
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                  Positioned(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomSubtitleLarge(
                              text: localizationManager.homeStepCount,
                              textColor: context.appColors.onPrimary,
                            ),
                            Obx(
                              () {
                                return CustomHeadlineLarge(
                                  text: NumberFormat("###,###,###,###")
                                      .format(pedometerController.todayWalkCount),
                                  textColor: context.appColors.onPrimary,
                                );
                              },
                            ),
                            Obx(
                              () {
                                return CustomBodyLarge(
                                  text: localizationManager.homeTotalSteps(
                                    NumberFormat("###,###,###,###").format(
                                      pedometerController.monthlyWalkCount,
                                    ),
                                  ),
                                  textColor: context.appColors.onPrimary,
                                  maxLines: 1,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!PermissionManager.isLocationPermissionGrantedStatic! ||
              !PermissionManager.isActivityPermissionGrantedStatic!)
            Positioned(
              child: CustomRoundedBorderedContainer(
                color: Colors.black.withValues(alpha: 0.8),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomSubtitleLarge(
                        text: localizationManager
                            .homeBEATRequiresLocationAndActivityPermissionTitle,
                        textColor: context.appColors.onPrimary,
                      ),
                      const SizedBox(height: 10),
                      CustomTextButtonWrap(
                        text: localizationManager.homeGotoSettings,
                        onTap: AppSettings.openAppSettings,
                      )
                    ],
                  ),
                ),
              ),
            )
          else
            Obx(
              () {
                if (pedometerController.isHoliday) {
                  return Positioned(
                    child: CustomRoundedBorderedContainer(
                      color: Colors.black.withValues(alpha: 0.8),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomSubtitleLarge(
                              text: localizationManager.homeNotEventDuration,
                              textColor: context.appColors.onPrimary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (pedometerController.isReachedMaxStepCount) {
                  return Positioned(
                    child: CustomRoundedBorderedContainer(
                      color: Colors.black.withValues(alpha: 0.8),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomSubtitleLarge(
                              text: localizationManager
                                  .homeReachedTodaysMaxStepCount,
                              textColor: context.appColors.onPrimary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
        ],
      ),
    );
  }
}
