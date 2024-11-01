import 'package:BEAT/controller/home/data_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../controller/home/quest_list_controller.dart';
import '../../../../data/states/data_list_state.dart';
import '../../../global/widgets/buttons/custom_refresh_button.dart';
import '../../../global/widgets/custom_circular_progress_indicator.dart';
import 'custom_quest_list_view.dart';

class HomeQuestList extends StatelessWidget {
  const HomeQuestList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuestListController(),
      child: BlocBuilder<QuestListController, DataListState>(
        builder: (context, state) {
          final QuestListController questListController =
              context.read<QuestListController>();

          if (state is DataListLoading) {
            return const CustomCircularProgressIndicator();
          } else if (state is DataListLoadingError) {
            return CustomRefreshButton(onTap: () => questListController.add(DataListRequest()));
          } else {
            return CustomQuestListView(list: state.dataList);
          }
        },
      ),
    );
  }
}