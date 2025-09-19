import 'dart:async';
import 'dart:developer';

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

  late Timer _timer;
  bool _denied = false;

  @override
  void initState() {
    // pedometerController.
    _checkPermission();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      _checkPermission();
    });
    super.initState();
  }

  Future<void> _checkPermission() async {
    final denied = await PermissionManager().isLocationPermissionDenied() ||
        await PermissionManager.isActivityPermissionDenied();

    if (_denied != denied) {
      setState(() {
        _denied = denied;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("PedometerCard : pedometerController.isEventDuration : ${pedometerController.isEventDuration}");
    log("PedometerCard : pedometerController.isHoliday : ${pedometerController.isHoliday}");

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Stack(
        children: [
          CustomRoundedBorderedContainer(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomSubtitleLarge(
                        text: localizationManager.homeStepCount,
                        textColor: context.appColors.onPrimary,
                      ),
                      Obx(
                        () {
                          return CustomHeadlineLarge(
                            text: NumberFormat("###,###,###,###")
                                .format(pedometerController.steps),
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
                          );
                        },
                      ),
                    ],
                  ),
                  SvgPicture.asset(
                    "assets/svg/footstep.svg",
                    width: 80,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ],
              ),
            ),
          ),
          if (_denied)
            Positioned(
              child: CustomRoundedBorderedContainer(
                color: Colors.black.withValues(alpha: 0.8),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomSubtitleLarge(text: localizationManager.homeBEATRequiresLocationAndActivityPermissionTitle),
                      const SizedBox(height: 10),
                      CustomTextButtonWrap(text: localizationManager.homeGotoSettings, onTap: AppSettings.openAppSettings,)
                    ],
                  ),
                ),
              ),
            )
          else if (!pedometerController.isEventDuration || pedometerController.isHoliday)
            Positioned(
              child: CustomRoundedBorderedContainer(
                color: Colors.black.withValues(alpha: 0.8),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomSubtitleLarge(text: localizationManager.homeNotEventDuration),
                    ],
                  ),
                ),
              ),
            )
          else if (pedometerController.isReachedTodaysMaxStepCount)
              Positioned(
                child: CustomRoundedBorderedContainer(
                  color: Colors.black.withValues(alpha: 0.8),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomSubtitleLarge(text: localizationManager.homeReachedTodaysMaxStepCount),
                      ],
                    ),
                  ),
                ),
              )
        ],
      ),
    );
  }

  Future<bool> _checkIsPedometerPermissionsDenied() async {
    return await PermissionManager().isLocationPermissionDenied() ||
        await PermissionManager.isActivityPermissionDenied();
  }
}
