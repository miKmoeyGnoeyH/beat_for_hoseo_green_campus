import 'package:BEAT/controller/home/events_controller.dart';
import 'package:BEAT/data/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/user_bloc.dart';
import '../global/widgets/custom_scaffold.dart';
import 'widgets/home_appbar.dart';
import 'widgets/neuroes_in_hand_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = context.read<UserBloc>();

    return BlocProvider<QuestsController>(
      create: (context) => QuestsController(),
      child: CustomScaffold(
        appBar: HomeAppbar(userBloc: userBloc),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Column(
            children: [
              NeuroesInHandCard(userBloc: userBloc),
              const SizedBox(height: 20),
              BlocBuilder<QuestsController, QuestsState>(
                  builder: (context, state) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.quests.length,
                    itemBuilder: (context, index) {
                      return Text(state.quests[index].eventName);
                    });
              }),
            ],
          ),
        ),
      ),
    );
  }

  const HomeScreen({super.key});
}
