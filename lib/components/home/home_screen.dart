import 'package:BEAT/components/home/widgets/quest_list/quest_list.dart';
import 'package:BEAT/components/home/widgets/quiz_list/quiz_list.dart';
import 'package:BEAT/components/home/widgets/survey_list/survey_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/user_bloc.dart';
import '../global/widgets/custom_scaffold.dart';
import 'widgets/home_appbar.dart';
import 'widgets/neuroes_in_hand_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = context.read<UserBloc>();

    return CustomScaffold(
      appBar: HomeAppbar(userBloc: userBloc),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: NeuroesInHandCard(userBloc: userBloc),
            ),
          ),
          const HomeQuestList(),
          const HomeQuizList(),
          const HomeSurveyList(),
          const SliverToBoxAdapter(child: SizedBox(height: 20,),)
        ],
      ),
    );
  }
}