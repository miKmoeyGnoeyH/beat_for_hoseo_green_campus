import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../data/models/data_models.dart';
import '../../global/widgets/custom_rounded_bordered_container.dart';
import '../../global/widgets/custom_text_field.dart';
import '../../global/widgets/texts/custom_body_large.dart';
import '../../global/widgets/texts/custom_subtitle_large.dart';
import 'quiz_question_contents_card.dart';
import 'quiz_question_title.dart';

class QuizQuestionSubjective extends StatefulWidget {
  const QuizQuestionSubjective({
    super.key,
    required this.quizDetailModel,
    required this.index,
  });

  @override
  State<QuizQuestionSubjective> createState() => _QuizQuestionSubjectiveState();

  final QuizDetailModel quizDetailModel;
  final int index;
}

class _QuizQuestionSubjectiveState extends State<QuizQuestionSubjective> {
  final TextEditingController _answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuizQuestionTitle(
          title: 'Q. ${widget.index + 1}',
          body: context.tr('subjective'),
        ),
        const SizedBox(height: 5),
        QuizQuestionContentsCard(
          title: questionModel.question,
          child: CustomTextField(
            textEditingController: _answerController,
            hintText: context.tr('writing_answers'),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  QuestionModel get questionModel =>
      widget.quizDetailModel.questionList[widget.index];
}
