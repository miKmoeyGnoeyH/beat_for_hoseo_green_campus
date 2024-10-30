import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/data_models.dart';
import '../../../global/widgets/custom_rounded_bordered_container.dart';
import 'survey_card_contents.dart';

class SurveyCard extends StatelessWidget {
  const SurveyCard({
    super.key,
    required this.index,
    required this.surveyModel,
  });

  @override
  Widget build(BuildContext context) {
    return CustomRoundedBorderedContainer(
      color: context.appColors.background,
      height: context.height * 0.11,
      borderWidth: 0.3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: SurveyCardContents(
          index: index,
          surveyModel: surveyModel,
        ),
      ),
    );
  }

  final int index;
  final SurveyModel surveyModel;
}