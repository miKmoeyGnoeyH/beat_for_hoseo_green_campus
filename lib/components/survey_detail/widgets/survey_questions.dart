import 'package:beat_flutter/components/survey_detail/widgets/survey_question.dart';
import 'package:beat_flutter/data/models/data_models.dart';
import 'package:flutter/material.dart';

class SurveyQuestions extends StatelessWidget {
  const SurveyQuestions({super.key, required this.questionList});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemBuilder: (context, index) => SurveyQuestion(
        index: index,
        surveyQuestionModel: questionList[index],
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemCount: questionList.length,
      // itemCount: 5,
    );
  }

  final List<SurveyQuestionModel> questionList;
}
