import 'package:BEAT/controller/home/survey_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/data_models.dart';
import '../../../../data/states/data_list_state.dart';
import 'survey_card.dart';

class HomeSurveyList extends StatelessWidget {
  const HomeSurveyList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SurveyListController(),
      child: BlocBuilder<SurveyListController, DataListState>(
        builder: (context, state) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
                  child: SurveyCard(
                    index: index,
                    surveyModel: state.dataList[index] as SurveyModel,
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