import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../controller/home/events_controller.dart';
import '../../../../data/models/event_model.dart';
import 'quest_card.dart';

class HomeQuestList extends StatelessWidget {
  const HomeQuestList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestsController, QuestsState>(
      builder: (context, state) {
        return Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: state.quests.length,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 20),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: QuestCard(
                  index: index,
                  questModel: state.quests[index],
                ),
              );
            },
          ),
        );
      },
    );
  }
}