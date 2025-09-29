import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../data/models/data_models.dart';
import '../methods/buildQuestDetailTableRows.dart';

class QuestDetailTableContents extends StatelessWidget {
  final LocalizationManager localizationManager = LocalizationManager();

  QuestDetailTableContents(
    this.questDetailModel, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
      child: Table(
        // columnWidths: const {0: FractionColumnWidth(.6)},
        // defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          buildQuestDetailTableRewardRow(
            reward: questDetailModel.neuro.toString(),
          ),
          buildQuestDetailTableQuestTypeRow(
            questType: questDetailModel.eventType,
          ),
          buildQuestDetailTableQuestRequirementRow(
            questRequirement: questDetailModel.eventType == EventType.qr
                ? localizationManager.qdQRs(NumberFormat("###,###,###,###")
                    .format((questDetailModel.eventLongDTO as EventQRLongDTO)
                        .qrMissionLongDTO
                        .successCondition))
                : localizationManager.qdSteps(
                    NumberFormat("###,###,###,###").format(
                        (questDetailModel.eventLongDTO as EventWalkLongDTO)
                            .walkCount),
                  ),
          ),
          if (questDetailModel.eventType == EventType.qr)
            buildQuestDetailTableBonusRewardRow(
              bonusReward: (questDetailModel.eventLongDTO as EventQRLongDTO)
                  .qrMissionLongDTO
                  .successPoint
                  .toString(),
            ),
          // buildQuestDetailTableLocationRow(
          //   questLocation: questDetailModel.eventLocation,
          // ),
        ],
      ),
    );
  }

  final QuestDetailModel questDetailModel;
}
