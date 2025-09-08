import 'package:flutter/material.dart';

import '../../../data/models/data_models.dart';
import '../methods/buildQuestDetailTableRows.dart';

class QuestDetailTableContents extends StatelessWidget {
  const QuestDetailTableContents(
    this.questDetailModel, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                ? (questDetailModel.eventLongDTO as EventQRLongDTO)
                    .qrMissionLongDTO
                    .successCondition
                    .toString()
                : (questDetailModel.eventLongDTO as EventWalkLongDTO)
                    .walkCount
                    .toString(),
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
