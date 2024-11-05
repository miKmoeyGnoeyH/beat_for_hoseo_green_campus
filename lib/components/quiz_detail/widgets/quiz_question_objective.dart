import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../data/models/data_models.dart';
import '../../global/widgets/custom_rounded_bordered_container.dart';
import '../../global/widgets/custom_text_field.dart';
import '../../global/widgets/texts/custom_body_large.dart';
import '../../global/widgets/texts/custom_subtitle_large.dart';
import 'quiz_question_contents_card.dart';
import 'quiz_question_obj_choices.dart';
import 'quiz_question_title.dart';

class QuizQuestionObjective extends StatefulWidget {
  const QuizQuestionObjective({
    super.key,
    required this.quizDetailModel,
    required this.index,
  });

  @override
  State<QuizQuestionObjective> createState() => _QuizQuestionObjectiveState();

  final QuizDetailModel quizDetailModel;
  final int index;
}

class _QuizQuestionObjectiveState extends State<QuizQuestionObjective> {
  int? _answerController;

  int? get answerController => _answerController;

  void setAnswerController(int? value) {
    setState(() {
      _answerController = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuizQuestionTitle(
          title: 'Q. ${widget.index + 1}',
          body: context.tr('objective'),
        ),
        const SizedBox(height: 5),
        QuizQuestionContentsCard(
          title: questionModel.question,
          child: QuizQuestionOBJChoices(
            onTap: setAnswerController,
            questionModel: questionModel,
            answerController: answerController,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  QuestionModel get questionModel =>
      widget.quizDetailModel.questionList[widget.index];
}