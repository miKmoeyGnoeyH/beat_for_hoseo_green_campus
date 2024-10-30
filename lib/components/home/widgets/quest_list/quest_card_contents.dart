import 'package:flutter/material.dart';

import '../../../../data/models/event_model.dart';
import 'quest_card_icon_and_neuro.dart';
import 'quest_card_title_and_desc.dart';

class QuestCardContents extends StatelessWidget {
  const QuestCardContents({
    super.key,
    required this.index,
    required this.questModel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        QuestCardTitleAndDesc(
          index: index,
          eventName: questModel.eventName,
          descriptionShort: questModel.descriptionShort,
        ),
        const SizedBox(width: 20),
        QuestCardIconAndNeuro(neuro: questModel.neuro),
      ],
    );
  }

  final int index;
  final QuestModel questModel;
}