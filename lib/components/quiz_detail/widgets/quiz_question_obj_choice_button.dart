import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../../../data/models/data_models.dart';
import '../../global/widgets/custom_rounded_bordered_container.dart';
import '../../global/widgets/texts/custom_body_large.dart';

class QuizQuestionOBJChoiceButton extends StatelessWidget {
  const QuizQuestionOBJChoiceButton({
    super.key,
    required this.jndex,
    required this.onTap,
    required this.answerController,
    required this.questionModel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null ? () => onTap!(jndex) : null,
      child: CustomRoundedBorderedContainer(
        margin: const EdgeInsets.symmetric(vertical: 5),
        color: jndex == answerController
            ? context.appColors.primary
            : context.appColors.background,
        borderColor: Colors.transparent,
        borderRadius: 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomBodyLarge(
            text: questionModel.answerList[jndex].answer,
            textColor: jndex == answerController
                ? context.appColors.background
                : context.appColors.onBackground,
          ),
        ),
      ),
    );
  }

  final int jndex;
  final void Function(int p1)? onTap;
  final int? answerController;
  final QuestionModel questionModel;
}