import 'package:beat_flutter/components/global/widgets/custom_rounded_bordered_container.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_body_large.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_headline_large.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_subtitle_large.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class PedometerCard extends StatelessWidget {
  final LocalizationManager localizationManager = LocalizationManager();

  PedometerCard(this.todayWalkCount, this.monthlyWalkCount, {super.key});

  @override
  Widget build(BuildContext context) {
    return CustomRoundedBorderedContainer(
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
                      CustomHeadlineLarge(
                        text: NumberFormat("###,###,###,###")
                            .format(todayWalkCount),
                        textColor: context.appColors.onPrimary,
                      ),
                      CustomBodyLarge(
                        text: localizationManager.homeTotalSteps(
                          NumberFormat("###,###,###,###").format(
                            monthlyWalkCount,
                          ),
                        ),
                        textColor: context.appColors.onPrimary,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  final int todayWalkCount;
  final int monthlyWalkCount;
}
