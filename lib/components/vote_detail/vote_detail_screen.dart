import 'package:BEAT/components/global/widgets/appbars/custom_empty_appbar.dart';
import 'package:BEAT/components/global/widgets/custom_scaffold.dart';
import 'package:BEAT/components/global/widgets/texts/custom_label_large.dart';
import 'package:BEAT/components/global/widgets/texts/custom_title_large.dart';
import 'package:BEAT/components/vote/methods/build_vote_status_badge_depends_on_status.dart';
import 'package:BEAT/controller/home/events/data_events.dart';
import 'package:BEAT/controller/vote/vote_detail_controller.dart';
import 'package:BEAT/data/models/data_models.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/states/data_state.dart';
import '../global/widgets/buttons/custom_refresh_button.dart';
import '../global/widgets/custom_circular_progress_indicator.dart';

class VoteDetailScreen extends StatelessWidget {
  const VoteDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final VoteDetailController voteDetailController =
        context.read<VoteDetailController>();

    return CustomScaffold(
      hasScrollBody: false,
      isScrollable: false,
      appBar: const CustomEmptyAppBar(),
      body: BlocBuilder<VoteDetailController, DataDetailModelState>(
          builder: (context, state) {
        if (state is DataDetailModelLoadingSuccess) {
          final VoteDetailModel voteDetailModel =
              state.dataModel as VoteDetailModel;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildVoteStatusBadgeDependsOnStatus(
                    context, voteDetailModel.bettingStatus),
                    CustomTitleLarge(text: voteDetailModel.bettingName),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomLabelLarge(text: context.tr('vote_title')),
                    CustomLabelLarge(
                        text: context.tr('vote_rules', gender: 'vote_rule_1')),
                    CustomLabelLarge(text: context.tr('vote_rules', gender: 'vote_rule_2')),
                  ],
                ),
              ],
            ),
          );
        } else if (state is DataDetailModelLoadingError) {
          return CustomRefreshButton(
              onTap: () => voteDetailController.add(DataDetailRequest()));
        } else {
          return const CustomCircularProgressIndicator();
        }
      }),
    );
  }
}
