
import 'package:flutter/material.dart';

import '../../../data/models/data_models.dart';
import 'ranking_card.dart';

class RankingListView extends StatelessWidget {
  const RankingListView({
    super.key,
    required this.rankingList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rankingList.length,
      separatorBuilder: (BuildContext context, int index) =>
      const SizedBox(height: 10),
      itemBuilder: (BuildContext context, int index) =>
          RankingCard(rankingList[index] as RankModel, index + 1),
    );
  }

  final List<DataModel> rankingList;
}