import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../theme/colors/palette.dart';
import '../widgets/custom_rounded_bordered_container.dart';
import '../widgets/texts/custom_body_large.dart';

Widget buildVoteStatusBadgeDependsOnStatus(String? bettingStatus) {
  switch (bettingStatus) {
    case '진행중':
      return CustomRoundedBorderedContainer(
        borderRadius: 5,
        color: Palette.inProgressBackground,
        width: null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
          child: CustomBodyLarge(
            text: 'in_progress'.tr(),
            textColor: Palette.inProgressText,
          ),
        ),
      );
    case '심사중':
      return CustomRoundedBorderedContainer(
        borderRadius: 5,
        color: Palette.underReviewBackground,
        width: null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
          child: CustomBodyLarge(
            text: 'under_review'.tr(),
            textColor: Palette.underReviewText,
          ),
        ),
      );
    case '종료':
      return CustomRoundedBorderedContainer(
        borderRadius: 5,
        color: Palette.endedBackground,
        width: null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
          child: CustomBodyLarge(
            text: 'ended'.tr(),
            textColor: Palette.endedText,
          ),
        ),
      );
    case '대기':
      return CustomRoundedBorderedContainer(
        borderRadius: 5,
        color: Palette.pendingBackground,
        width: null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
          child: CustomBodyLarge(
            text: 'pending'.tr(),
          ),
        ),
      );
    default:
      return const SizedBox();
  }
}