import 'package:BEAT/components/vote/widgets/vote_card.dart';
import 'package:BEAT/data/states/data_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/home/events/data_events.dart';
import '../../controller/vote/vote_controller.dart';
import '../../data/models/data_models.dart';
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
    return BlocProvider(
      create: (context) => VoteController(),
      child:
          BlocBuilder<VoteController, DataListState>(builder: (context, state) {
        final VoteController voteController = context.read<VoteController>();
        if (state is DataListLoading) {
          return const CustomCircularProgressIndicator();
        } else if (state is DataListLoadingError) {
          return CustomRefreshButton(
              onTap: () => voteController.add(DataListRequest()));
        } else {
          return Center(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemCount: state.dataList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) => VoteCard(
                index: index,
                voteModel: state.dataList[index] as VoteModel,
              ),
            ),
          );
        }
      }),
    );
  }
}
