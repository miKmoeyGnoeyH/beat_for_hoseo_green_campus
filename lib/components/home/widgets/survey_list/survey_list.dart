import 'package:BEAT/controller/home/survey_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../controller/home/data_events.dart';
import '../../../../data/states/data_list_state.dart';
import '../../../global/widgets/buttons/custom_refresh_button.dart';
import '../../../global/widgets/custom_circular_progress_indicator.dart';
import 'custom_survey_list_view.dart';

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
          final SurveyListController surveyListController =
              context.read<SurveyListController>();

          if (state is DataListLoading) {
            return const CustomCircularProgressIndicator();
          } else if (state is DataListLoadingError) {
            return CustomRefreshButton(onTap: () => surveyListController.add(DataListRequest()));
          } else {
            return CustomSurveyListView(list: state.dataList);
          }
        },
      ),
    );
  }
}
