import 'package:flutter/material.dart';

import '../../../data/models/data_models.dart';
import 'quiz_question_obj_choice_button.dart';

class QuizQuestionOBJChoices extends StatelessWidget {
  const QuizQuestionOBJChoices({
    super.key,
    required this.questionModel,
    required this.answerController,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: questionModel.answerList.length,
      itemBuilder: (context, jndex) => QuizQuestionOBJChoiceButton(
        jndex: jndex,
        onTap: onTap,
        answerController: answerController,
        questionModel: questionModel,
      ),
    );
  }

  final QuestionModel questionModel;
  final int? answerController;
  final void Function(int)? onTap;
}