import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/data_models.dart';
import '../../../global/widgets/custom_rounded_bordered_container.dart';
import 'quiz_card_contents.dart';

class QuizCard extends StatelessWidget {
  const QuizCard({
    super.key,
    required this.index,
    required this.quizModel,
  });

  @override
  Widget build(BuildContext context) {
    return CustomRoundedBorderedContainer(
      color: context.appColors.background,
      borderWidth: 0.3,
      height: context.height * 0.12,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: QuizCardContents(
          index: index,
          quizModel: quizModel,
        ),
      ),
    );
  }

  final int index;
  final QuizModel quizModel;
}