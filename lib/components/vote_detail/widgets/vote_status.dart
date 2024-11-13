import 'package:flutter/material.dart';

import '../../vote/methods/build_vote_status_badge_depends_on_status.dart';

class VoteStatus extends StatelessWidget {
  const VoteStatus(this.voteStatus, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildVoteStatusBadgeDependsOnStatus(
            context, voteStatus),
      ],
    );
  }

  final String voteStatus;
}