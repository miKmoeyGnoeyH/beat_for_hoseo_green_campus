import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../data/models/data_models.dart';
import 'vote_card_icon_and_neuro.dart';
import 'vote_card_title_and_desc.dart';


class VoteCardContents extends StatelessWidget {
  const VoteCardContents({
    super.key,
    required this.index,
    required this.voteModel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VoteCardTitleAndDesc(
          index: index,
          eventName: voteModel.bettingName.toString(),
          descriptionShort: context.tr('vote_end_date', args: [voteModel.bettingEndTime ?? '']),
          gatheredNeuro: voteModel.gatheredNeuro.toString(),
        ),
        const SizedBox(width: 20),
        VoteCardIconAndNeuro(bettingStatus: voteModel.bettingStatus.toString()),
      ],
    );
  }

  final int index;
  final VoteModel voteModel;
}