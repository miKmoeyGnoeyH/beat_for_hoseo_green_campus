import 'package:flutter/material.dart';

import '../../../data/models/data_models.dart';
import 'vote_result_winner_and_my_vote_neuro.dart';

class VoteResultNstWinners extends StatelessWidget {
  const VoteResultNstWinners({
    super.key,
    required this.voteResultWinners,
    required this.nstTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        nstTitle,
        const SizedBox(height: 10),
        for (QuestVoteResultModel questVoteResultModel in voteResultWinners)
          VoteResultWinnerAndMyVoteNeuro(
            questVoteResultModel: questVoteResultModel,
            eventName: questVoteResultModel.eventName,
            voteNeuro: questVoteResultModel.voteNeuro.toString(),
          ),
      ],
    );
  }

  final Widget nstTitle;
  final List<QuestVoteResultModel> voteResultWinners;
}