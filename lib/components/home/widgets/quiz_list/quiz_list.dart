import 'package:BEAT/controller/home/quiz_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/data_models.dart';
import '../../../../data/states/data_list_state.dart';
import 'quiz_card.dart';

class HomeQuizList extends StatelessWidget {
  const HomeQuizList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizListController(),
      child: BlocBuilder<QuizListController, DataListState>(
        builder: (context, state) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
                  child: QuizCard(
                    index: index,
                    quizModel: state.dataList[index] as QuizModel,
                  ),
                );
              },
              childCount: state.dataList.length,
            ),
          );
        },
      ),
    );
  }
}