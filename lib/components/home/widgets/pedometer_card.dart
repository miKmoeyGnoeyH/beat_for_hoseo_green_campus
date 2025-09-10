
import 'package:beat_flutter/components/global/widgets/custom_rounded_bordered_container.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_body_large.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_headline_large.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_subtitle_large.dart';
import 'package:beat_flutter/controller/pedometer/pedometer_controller.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
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

  @override
  void initState() {
    // pedometerController.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: CustomRoundedBorderedContainer(
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
    );
  }
}
