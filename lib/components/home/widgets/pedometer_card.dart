import 'package:beat_flutter/components/global/widgets/custom_rounded_bordered_container.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_body_large.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_headline_large.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_subtitle_large.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class PedometerCard extends StatelessWidget {
  PedometerCard({super.key});

  final LocalizationManager localizationManager = LocalizationManager();

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
                  CustomHeadlineLarge(
                    text: NumberFormat("###,###,###,###").format(9366),
                    textColor: context.appColors.onPrimary,
                  ),
                  CustomBodyLarge(
                    text: localizationManager.homeTotalSteps(
                        NumberFormat("###,###,###,###").format(12223)),
                    textColor: context.appColors.onPrimary,
                  )
                ],
              ),
              SvgPicture.asset(
                "assets/svg/footstep.svg",
                width: 80,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
