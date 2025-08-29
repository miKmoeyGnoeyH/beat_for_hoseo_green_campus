import 'package:beat_flutter/controller/home/controllers/quest_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../controller/home/events/data_events.dart';
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
    final QuestListController questListController =
        context.read<QuestListController>();

    return BlocBuilder<QuestListController, DataListState>(
      builder: (context, state) {
        if (state is DataListLoading) {
          return const SizedBox(
            height: 400,
            child: Center(
              child: CustomCircularProgressIndicator(),
            ),
          );
        } else if (state is DataListLoadingError) {
          return SizedBox(
            height: 400,
            child: CustomRefreshButton(
                onTap: () => questListController.add(DataListRequest())),
          );
        } else {
          // return const CustomCircularProgressIndicator();
          return CustomQuestListView(list: state.dataList);
          // return CustomQuestListView(list: []);
        }
      },
    );
  }
}
