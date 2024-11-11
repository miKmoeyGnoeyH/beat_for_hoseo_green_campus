import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../controller/home/controllers/quiz_list_controller.dart';
import '../../../../controller/home/events/data_events.dart';
import '../../../../data/states/data_list_state.dart';
import '../../../global/widgets/buttons/custom_refresh_button.dart';
import '../../../global/widgets/custom_circular_progress_indicator.dart';
import 'custom_quiz_list_view.dart';

class HomeQuizList extends StatelessWidget {
  const HomeQuizList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final QuizListController quizListController =
        context.read<QuizListController>();

    return BlocBuilder<QuizListController, DataListState>(
      builder: (context, state) {
        if (state is DataListLoading) {
          return const CustomCircularProgressIndicator();
        } else if (state is DataListLoadingError) {
          return CustomRefreshButton(
              onTap: () => quizListController.add(DataListRequest()));
        } else {
          return CustomQuizListView(list: state.dataList);
        }
      },
    );
  }
}
