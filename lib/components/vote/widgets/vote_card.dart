import 'package:BEAT/controller/user_controller.dart';
import 'package:BEAT/controller/vote/controllers/vote_list_controller.dart';
import 'package:BEAT/data/states/vote_list_state.dart';
import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:BEAT/managers/navigator/arguments/vote_detail_arguments.dart';
import 'package:BEAT/managers/navigator/arguments/vote_result_args.dart';
import 'package:BEAT/managers/navigator/navigator_key_manager.dart';
import 'package:BEAT/managers/navigator/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/data_models.dart';
import '../../global/widgets/custom_rounded_bordered_container.dart';
import 'vote_card_contents.dart';

class VoteCard extends StatelessWidget {
  const VoteCard({
    super.key,
    required this.index,
    required this.voteModel,
  });

  @override
  Widget build(BuildContext context) {
    final VoteListController voteListController =
        context.read<VoteListController>();

    return GestureDetector(
      onTap: () {
        if (voteModel.bettingStatus == '종료') {
          NavigatorKeyManager().pushNamed(
            RouteNames.voteResult,
            arguments: VoteResultArguments(
              voteModel: voteModel,
              authorization: context.read<UserController>().state.authorization,
            ),
          );
        } else {
          List<ChoiceVoteModel> choiceListFormList = [];

          for (var element
              in (voteListController.state as VoteListLoadingSuccess)
                  .voteList
                  .choiceListFormList) {
            if (element.bettingId == voteModel.bettingId) {
              choiceListFormList.add(element);
            }
          }

          NavigatorKeyManager().pushNamed(
            RouteNames.voteDetail,
            arguments: VoteDetailArguments(
              voteModel,
              choiceListFormList,
              voteListController
            ),
          );
        }
      },
      child: CustomRoundedBorderedContainer(
        color: context.appColors.background,
        borderWidth: 0.5,
        // height: context.height * 0.13,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: VoteCardContents(
            index: index,
            voteModel: voteModel,
          ),
        ),
      ),
    );
  }

  final int index;
  final VoteModel voteModel;
}
