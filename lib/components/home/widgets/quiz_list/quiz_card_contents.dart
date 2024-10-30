import 'package:flutter/material.dart';

import '../../../../data/models/data_models.dart';
import 'quiz_card_icon_and_neuro.dart';
import 'quiz_card_title_and_desc.dart';

class QuizCardContents extends StatelessWidget {
  const QuizCardContents({
    super.key,
    required this.index,
    required this.quizModel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        QuizCardTitleAndDesc(
          index: index,
          title: quizModel.title,
          content: quizModel.content,
        ),
        const SizedBox(width: 20),
        QuizCardIconAndNeuro(neuro: quizModel.neuro),
      ],
    );
  }

  final int index;
  final QuizModel quizModel;
}
