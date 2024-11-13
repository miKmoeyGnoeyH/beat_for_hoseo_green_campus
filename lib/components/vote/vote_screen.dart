import 'package:BEAT/components/vote/widgets/vote_card.dart';
import 'package:BEAT/controller/user_controller.dart';
import 'package:BEAT/controller/vote/event/vote_list_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/vote/controllers/vote_list_controller.dart';
import '../../data/states/vote_list_state.dart';
import '../global/widgets/buttons/custom_refresh_button.dart';
import '../global/widgets/custom_circular_progress_indicator.dart';

class VoteScreen extends StatefulWidget {
  const VoteScreen({super.key});

  @override
  State<VoteScreen> createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  @override
  Widget build(BuildContext context) {
    final UserController userController = context.read<UserController>();
    final VoteListController voteController =
        context.read<VoteListController>();

    return BlocBuilder<VoteListController, VoteListState>(
        builder: (context, state) {
      if (state is VoteListLoading) {
        return const CustomCircularProgressIndicator();
      } else if (state is VoteListLoadingError) {
        return CustomRefreshButton(
            onTap: () => voteController
                .add(VoteListRequest(userController.state.authorization)));
      } else {
        return Center(
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: (state as VoteListLoadingSuccess)
                .voteList
                .bettingListFormList
                .length,
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            itemBuilder: (context, index) => VoteCard(
              index: index,
              voteModel: (state).voteList.bettingListFormList[index],
            ),
          ),
        );
      }
    });
  }
}
