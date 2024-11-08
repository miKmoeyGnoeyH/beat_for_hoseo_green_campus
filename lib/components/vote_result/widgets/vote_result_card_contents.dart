import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../data/models/data_models.dart';
import '../../global/widgets/texts/custom_title_large.dart';
import 'vote_result_1st_title.dart';
import 'vote_result_2nd_title.dart';
import 'vote_result_3rd_title.dart';
import 'vote_result_nst_winners.dart';

class VoteResultCardContents extends StatelessWidget {
  const VoteResultCardContents({
    super.key,
    required this.voteResult1sts,
    required this.voteResult2nds,
    required this.voteResult3rds,
  });

  final List<QuestVoteResultModel> voteResult1sts;
  final List<QuestVoteResultModel> voteResult2nds;
  final List<QuestVoteResultModel> voteResult3rds;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTitleLarge(
          text: context.tr('result'),
        ),
        const SizedBox(height: 20),
        VoteResultNstWinners(
          nstTitle: const VoteResult1stTitle(),
          voteResultWinners: voteResult1sts,
        ),
        const SizedBox(height: 10),
        VoteResultNstWinners(
          nstTitle: const VoteResult2ndTitle(),
          voteResultWinners: voteResult2nds,
        ),
        const SizedBox(height: 10),
        VoteResultNstWinners(
          nstTitle: const VoteResult3rdTitle(),
          voteResultWinners: voteResult3rds,
        ),
      ],
    );
  }
}