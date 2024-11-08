import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../data/models/data_models.dart';
import '../../global/widgets/texts/custom_body_large.dart';
import '../../global/widgets/texts/custom_label_large.dart';

class VoteResultWinnerAndMyVoteNeuro extends StatelessWidget {
  const VoteResultWinnerAndMyVoteNeuro({
    super.key,
    required this.questVoteResultModel,
    required this.eventName,
    required this.voteNeuro,
  });

  final QuestVoteResultModel questVoteResultModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomBodyLarge(
          text: questVoteResultModel.eventName,
        ),
        CustomLabelLarge(
          text: context.tr('my_vote_neuro',
              args: [questVoteResultModel.voteNeuro.toString()]),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  final String eventName;
  final String voteNeuro;
}