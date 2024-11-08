import 'package:BEAT/components/vote_result/widgets/vote_result_card_contents.dart';
import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../../../data/models/data_models.dart';
import '../../global/widgets/custom_rounded_bordered_container.dart';

class VoteResultCard extends StatelessWidget {
  const VoteResultCard({
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
    return CustomRoundedBorderedContainer(
      color: context.appColors.background,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: VoteResultCardContents(
          voteResult1sts: voteResult1sts,
          voteResult2nds: voteResult2nds,
          voteResult3rds: voteResult3rds,
        ),
      ),
    );
  }
}