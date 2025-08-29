import 'package:beat_flutter/components/global/widgets/custom_rounded_bordered_container.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_body_large.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_subtitle_large.dart';
import 'package:beat_flutter/components/home/widgets/quest_list/quest_card_icon_and_neuro.dart';
import 'package:beat_flutter/components/quest_detail/widgets/additional_info_card_icon_and_point.dart';
import 'package:beat_flutter/data/models/data_models.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

class QuestDetailAdditionalInfoCard extends StatelessWidget {
  const QuestDetailAdditionalInfoCard({super.key, required this.qrMissionDTO});

  @override
  Widget build(BuildContext context) {
    return CustomRoundedBorderedContainer(
      color: context.appColors.background,
      borderWidth: 0.5,
      // height: context.height * 0.15,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSubtitleLarge(text: qrMissionDTO.eventQRName),
                const SizedBox(height: 5),
                CustomBodyLarge(
                  text: qrMissionDTO.qrLocation,
                  textColor:
                      context.appColors.onBackground.withValues(alpha: 0.5),
                  maxLines: 2,
                ),
              ],
            ),
            AdditionalInfoCardIconAndPoint(point: qrMissionDTO.qrRewardPoint.toString())
          ],
        ),
      ),
    );
  }

  final QRMissionDTO qrMissionDTO;
}
