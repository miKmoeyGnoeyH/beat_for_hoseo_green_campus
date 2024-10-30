import 'package:flutter/material.dart';

import '../../../../data/models/data_models.dart';
import 'survey_card.dart';

class CustomSurveyListView extends StatelessWidget {
  const CustomSurveyListView({
    super.key,
    required this.list,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      padding: const EdgeInsets.symmetric(vertical: 20),
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return SurveyCard(
          index: index,
          surveyModel: list[index] as SurveyModel,
        );
      },
    );
  }

  final List<dynamic> list;
  final Widget? child;
}