import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../global/beat/neuro.dart';
import '../../global/widgets/texts/custom_body_large.dart';
import '../../global/widgets/texts/custom_subtitle_large.dart';

TableRow buildQuestDetailTableRewardRow({required String reward}) {
  return TableRow(children: [
    TableCell(
      child: CustomSubtitleLarge(
        text: 'reward'.tr(),
      ),
    ),
    TableCell(
      child: Row(
        children: [
          const Neuro(width: 20),
          const SizedBox(width: 5),
          CustomSubtitleLarge(
            text: reward,
          ),
        ],
      ),
    ),
  ]);
}

TableRow buildQuestDetailTableQuestTypeRow({required String? questType}) {
  return TableRow(children: [
    TableCell(
      child: CustomSubtitleLarge(
        text: 'quest_type'.tr(),
      ),
    ),
    TableCell(
      child: Column(
        children: [
          const SizedBox(height: 10),
          CustomBodyLarge(text: questType),
          const SizedBox(height: 10),
        ],
      ),
    ),
  ]);
}

TableRow buildQuestDetailTableLocationRow({required String? questLocation}) {
  return TableRow(children: [
    TableCell(
      child: CustomSubtitleLarge(
        text: 'location'.tr(),
      ),
    ),
    TableCell(
      child: CustomBodyLarge(text: questLocation),
    ),
  ]);
}