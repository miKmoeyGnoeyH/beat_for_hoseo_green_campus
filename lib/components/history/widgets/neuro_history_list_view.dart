import 'package:flutter/material.dart';

import '../../../data/models/neuro_history_model.dart';
import 'neuro_history_card.dart';

class NeuroHistoryListView extends StatelessWidget {
  const NeuroHistoryListView({
    super.key,
    required this.neuroHistoryList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: neuroHistoryList.length,
      separatorBuilder: (BuildContext context, int index) =>
      const SizedBox(height: 10),
      itemBuilder: (BuildContext context, int index) =>
          NeuroHistoryCard(neuroHistoryList[index]),
    );
  }

  final List<NeuroHistoryModel> neuroHistoryList;
}