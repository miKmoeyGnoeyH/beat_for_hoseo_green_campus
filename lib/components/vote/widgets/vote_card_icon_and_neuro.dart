import 'package:BEAT/components/global/methods/build_vote_status_badge_depends_on_status.dart';
import 'package:flutter/material.dart';

class VoteCardIconAndNeuro extends StatelessWidget {
  const VoteCardIconAndNeuro({
    super.key,
    required this.bettingStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildVoteStatusBadgeDependsOnStatus(bettingStatus),
      ],
    );
  }

  final String bettingStatus;
}
