import 'package:beat_flutter/components/global/beat/gc_point.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_subtitle_medium.dart';
import 'package:beat_flutter/data/models/data_models.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../global/widgets/texts/custom_body_large.dart';
import '../../global/widgets/texts/custom_subtitle_large.dart';

TableRow buildQuestDetailTableRewardRow({required String reward}) {
  return TableRow(
    children: [
      TableCell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomSubtitleMedium(
              text: LocalizationManager().qdTotalReward,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GreenCampusPoint(width: 25.w),
                SizedBox(width: 5.w),
                CustomSubtitleMedium(
                  text: reward,
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

TableRow buildQuestDetailTableQuestTypeRow({required EventType? questType}) {
  final LocalizationManager localizationManager = LocalizationManager();
  final String questTypeString = switch (questType) {
    EventType.qr => localizationManager.qdQuestTypeQR,
    EventType.walk => localizationManager.qdQuestTypeWalk,
    _ => '',
  };

  return TableRow(
    children: [
      TableCell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomSubtitleMedium(
              text: LocalizationManager().qdQuestType,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.w),
                CustomBodyLarge(text: questTypeString),
                SizedBox(height: 10.w),
              ],
            ),
          ],
        ),
      ),
      // TableCell(
      // ),
    ],
  );
}

TableRow buildQuestDetailTableLocationRow({required String? questLocation}) {
  return TableRow(
    children: [
      TableCell(
        child: CustomSubtitleMedium(
          text: 'location'.tr(),
        ),
      ),
      TableCell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.w),
            CustomBodyLarge(text: questLocation),
            SizedBox(height: 10.w),
          ],
        ),
      ),
    ],
  );
}

TableRow buildQuestDetailTableQuestRequirementRow(
    {required String? questRequirement}) {
  return TableRow(
    children: [
      TableCell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomSubtitleMedium(
              text: LocalizationManager().qdQuestRequirement,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.w),
                CustomBodyLarge(text: questRequirement),
                SizedBox(height: 10.w),
              ],
            )
          ],
        ),
      ),
      // TableCell(
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       const SizedBox(height: 10),
      //       CustomBodyLarge(text: questRequirement),
      //       const SizedBox(height: 10),
      //     ],
      //   ),
      // ),
    ],
  );
}

TableRow buildQuestDetailTableBonusRewardRow({required String? bonusReward}) {
  return TableRow(
    children: [
      TableCell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomSubtitleMedium(
              text: LocalizationManager().qdBonusReward,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.w),
                CustomBodyLarge(text: bonusReward),
                SizedBox(height: 10.w),
              ],
            )
          ],
        ),
      ),
      // TableCell(
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       // const SizedBox(height: 10),
      //       CustomBodyLarge(text: bonusReward),
      //       // const SizedBox(height: 10),
      //     ],
      //   ),
      // ),
    ],
  );
}
