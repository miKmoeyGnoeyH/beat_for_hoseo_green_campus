
import 'package:beat_flutter/controller/user_controller.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/data_models.dart';
import '../../global/widgets/custom_rounded_bordered_container.dart';
import 'rank_and_nickname.dart';
import 'rank_neuro.dart';

class RankingCard extends StatelessWidget {
  const RankingCard(
    this.ranking,
    this.rank, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final UserController userController = context.read<UserController>();

    return CustomRoundedBorderedContainer(
      borderWidth: 0.5,
      color: context.appColors.background,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RankAndNickname(rank: rank, ranking: ranking),
            RankNeuro(ranking: ranking)
          ],
        ),
      ),
    );
  }

  final RankItemModel ranking;
  final int rank;
}