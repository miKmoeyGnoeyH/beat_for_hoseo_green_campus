import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../theme/colors/palette.dart';
import '../../global/widgets/custom_rounded_bordered_container.dart';
import '../../global/widgets/texts/custom_body_large.dart';

Widget buildVoteStatusBadgeDependsOnStatus(BuildContext context, String? bettingStatus) {
  switch (bettingStatus) {
    case '진행중':
      return CustomRoundedBorderedContainer(
        borderRadius: 5,
        color: Palette.inProgress.withOpacity(0.2),
        width: null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
          child: CustomBodyLarge(
            text: 'in_progress'.tr(),
            textColor: Palette.inProgress,
          ),
        ),
      );
    case '심사중':
      return CustomRoundedBorderedContainer(
        borderRadius: 5,
        color: Palette.underReview.withOpacity(0.2),
        width: null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
          child: CustomBodyLarge(
            text: 'under_review'.tr(),
            textColor: Palette.underReview,
          ),
        ),
      );
    case '종료':
      return CustomRoundedBorderedContainer(
        borderRadius: 5,
        color: Palette.ended.withOpacity(0.2),
        width: null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
          child: CustomBodyLarge(
            text: 'ended'.tr(),
            textColor: Palette.ended,
          ),
        ),
      );
    case '대기':
      return CustomRoundedBorderedContainer(
        borderRadius: 5,
        color: Palette.pending.withValues(alpha: 0.2),
        width: null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
          child: CustomBodyLarge(
            text: 'pending'.tr(),
            textColor: context.appColors.onBackground,
          ),
        ),
      );
    default:
      return const SizedBox();
  }
}