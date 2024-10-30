import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../controller/home/quest_list_controller.dart';
import '../../../../data/models/data_models.dart';
import '../../../../data/states/data_list_state.dart';
import 'quest_card.dart';

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
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.dataList.length,
            padding: const EdgeInsets.symmetric(vertical: 20),
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return QuestCard(
                index: index,
                questModel: state.dataList[index] as QuestModel,
              );
            },
          );
        },
      ),
    );
  }
}