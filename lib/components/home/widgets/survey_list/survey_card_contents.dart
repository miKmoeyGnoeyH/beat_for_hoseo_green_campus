import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/data_models.dart';
import 'survey_card_title_and_desc.dart';

class SurveyCardContents extends StatelessWidget {
  SurveyCardContents({
    super.key,
    required this.index,
    required this.surveyModel,
  });

  final LocalizationManager localizationManager = LocalizationManager();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SurveyCardTitleAndDesc(
          index: index,
          title: surveyModel.title,
          content: localizationManager.homeSurveyDesc,
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  final int index;
  final SurveyModel surveyModel;
}
