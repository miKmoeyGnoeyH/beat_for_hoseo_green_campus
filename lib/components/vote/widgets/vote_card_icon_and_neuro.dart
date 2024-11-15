
import 'package:flutter/material.dart';

import '../methods/build_vote_status_badge_depends_on_status.dart';

class VoteCardIconAndNeuro extends StatelessWidget {
  const VoteCardIconAndNeuro({
    super.key,
    required this.bettingStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildVoteStatusBadgeDependsOnStatus(context, bettingStatus),
      ],
    );
  }

  final String bettingStatus;
}
