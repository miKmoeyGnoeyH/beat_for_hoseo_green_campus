import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../data/models/data_models.dart';
import '../../global/widgets/custom_text_field.dart';
import 'quiz_question_contents_card.dart';
import 'quiz_question_obj_choices.dart';
import 'quiz_question_title.dart';

class QuizQuestion extends StatefulWidget {
  QuizQuestion({
    super.key,
    required this.quizDetailModel,
    required this.index,
  });

  Map<String, dynamic> Function()? questionToJson;
  final QuizDetailModel quizDetailModel;
  final int index;

  @override
  State<QuizQuestion> createState() => _QuizQuestionState();
}

class _QuizQuestionState extends State<QuizQuestion> {
  final TextEditingController subjectiveAnswerController =
      TextEditingController();
  int? objectiveAnswerController;

  Map<String, dynamic> questionToJson() {
    String answerString;
    if (objectiveAnswerController != null) {
      answerString = questionModel.answerList[objectiveAnswerController!].answer
          .toString();
    } else {
      if (subjectiveAnswerController.text != '') {
        answerString = subjectiveAnswerController.text;
      } else {
        return {};
      }
    }

    Map<String, dynamic> question = {};
    question['quizQuestionId'] = questionModel.questionId;

    Map<String, dynamic> answer = {};
    answer['questionId'] = questionModel.questionId;
    answer['answerList'] = [answerString];

    question['answerList'] = List<Map<String, dynamic>>.empty(growable: true);
    question['answerList'].add(answer);

    return question;
  }

  void setOBJAnswerController(int? value) {
    setState(() {
      objectiveAnswerController = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.questionToJson = questionToJson;

    return Column(
      children: [
        QuizQuestionTitle(
          title: 'Q. ${widget.index + 1}',
          body: questionModel.subjective
              ? context.tr('subjective')
              : context.tr('objective'),
        ),
        const SizedBox(height: 5),
        QuizQuestionContentsCard(
          title: questionModel.question,
          imageUrl: questionModel.imageUrl,
          child: questionModel.subjective
              ? CustomTextField(
                textEditingController: subjectiveAnswerController,
                hintText: context.tr('writing_answers'),
              )
              : QuizQuestionOBJChoices(
                  onTap: setOBJAnswerController,
                  questionModel: questionModel,
                  answerController: objectiveAnswerController,
                ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  QuestionModel get questionModel =>
      widget.quizDetailModel.questionList[widget.index];
}
