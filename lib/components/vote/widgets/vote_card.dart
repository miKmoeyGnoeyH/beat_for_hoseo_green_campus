import 'package:BEAT/controller/user_controller.dart';
import 'package:BEAT/extensions/buildcontext_extension.dart';
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
    return GestureDetector(
      onTap: () {
        if (voteModel.bettingStatus == '종료') {
          NavigatorKeyManager().pushNamed(
            RouteNames.voteResult,
            arguments: VoteResultArguments(
                voteModel: voteModel,
                authorization: context.read<UserController>().state.authorization),
          );
        } else {
          NavigatorKeyManager().pushNamed(RouteNames.voteDetail, arguments: voteModel);
        }
      },
      child: CustomRoundedBorderedContainer(
        color: context.appColors.background,
        borderWidth: 0.3,
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
