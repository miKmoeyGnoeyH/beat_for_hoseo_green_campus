import 'package:BEAT/components/global/widgets/appbars/custom_empty_appbar.dart';
import 'package:BEAT/components/global/widgets/custom_scaffold.dart';
import 'package:BEAT/controller/home/events/data_events.dart';
import 'package:BEAT/data/models/data_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/vote/vote_result_controller.dart';
import '../../data/states/data_state.dart';
import '../global/widgets/buttons/custom_refresh_button.dart';
import '../global/widgets/custom_circular_progress_indicator.dart';
import 'widgets/vote_result_card.dart';
import 'widgets/vote_result_title.dart';

class VoteResultScreen extends StatelessWidget {
  const VoteResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final VoteResultController voteResultController =
        context.read<VoteResultController>();

    return CustomScaffold(
      hasScrollBody: false,
      isScrollable: false,
      appBar: const CustomEmptyAppBar(),
      body: BlocBuilder<VoteResultController, DataDetailModelState>(
          builder: (context, state) {
        if (state is DataDetailModelLoadingSuccess) {
          List<QuestVoteResultModel> voteResult1sts = [];
          List<QuestVoteResultModel> voteResult2nds = [];
          List<QuestVoteResultModel> voteResult3rds = [];

          for (QuestVoteResultModel questVoteResultModel
              in (state.dataModel as VoteResultModel).bettingEventList) {
            switch (questVoteResultModel.result) {
              case '1등':
                voteResult1sts.add(questVoteResultModel);
                break;
              case '2등':
                voteResult2nds.add(questVoteResultModel);
                break;
              case '3등':
              default:
                voteResult3rds.add(questVoteResultModel);
                break;
            }
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VoteDetailTitle(
                  bettingStatus:
                      (state.dataModel as VoteResultModel).bettingStatus,
                  bettingName: (state.dataModel as VoteModel).bettingName,
                ),
                const SizedBox(height: 10),
                VoteResultCard(
                  voteResult1sts: voteResult1sts,
                  voteResult2nds: voteResult2nds,
                  voteResult3rds: voteResult3rds,
                ),
              ],
            ),
          );
        } else if (state is DataDetailModelLoadingError) {
          return CustomRefreshButton(
              onTap: () => voteResultController.add(DataDetailRequest()));
        } else {
          return const CustomCircularProgressIndicator();
        }
      }),
    );
  }
}




