import 'package:flutter/material.dart';

import '../../vote/methods/build_vote_status_badge_depends_on_status.dart';
import '../../global/widgets/texts/custom_title_large.dart';

class VoteDetailTitle extends StatelessWidget {
  const VoteDetailTitle({
    super.key,
    this.bettingStatus,
    this.bettingName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildVoteStatusBadgeDependsOnStatus(context, bettingStatus),
        const SizedBox(height: 10),
        CustomTitleLarge(
          text: bettingName,
        ),
      ],
    );
  }

  final String? bettingStatus;
  final String? bettingName;
}
