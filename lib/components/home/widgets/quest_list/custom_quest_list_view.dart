import 'package:flutter/material.dart';

import '../../../../data/models/data_models.dart';
import 'quest_card.dart';

class CustomQuestListView extends StatelessWidget {
  const CustomQuestListView({
    super.key,
    required this.list,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      padding: const EdgeInsets.symmetric(vertical: 20),
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return QuestCard(
          index: index,
          questModel: list[index] as QuestModel,
        );
      },
    );
  }

  final List<dynamic> list;
  final Widget? child;
}