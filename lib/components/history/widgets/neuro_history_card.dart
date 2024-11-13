import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../../../data/models/neuro_history_model.dart';
import '../../global/widgets/custom_rounded_bordered_container.dart';
import '../../home/widgets/quest_list/quest_card_icon_and_neuro.dart';
import 'neuro_history_contents_desc.dart';

class NeuroHistoryCard extends StatelessWidget {
  const NeuroHistoryCard(
    this.neuroHistory, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomRoundedBorderedContainer(
      color: context.appColors.background,
      borderWidth: 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            NeuroHistoryContentsDesc(
              type: neuroHistory.type,
              historyName: neuroHistory.historyName,
              checkTime: neuroHistory.checkTime,
            ),
            const SizedBox(width: 16),
            QuestCardIconAndNeuro(
              neuro: neuroHistory.neuro >= 0
                  ? '+${neuroHistory.neuro.toString()}'
                  : neuroHistory.neuro.toString(),
              textColor: neuroHistory.neuro >= 0
                  ? Colors.redAccent
                  : Colors.blueAccent,
            )
          ],
        ),
      ),
    );
  }

  final NeuroHistoryModel neuroHistory;
}
