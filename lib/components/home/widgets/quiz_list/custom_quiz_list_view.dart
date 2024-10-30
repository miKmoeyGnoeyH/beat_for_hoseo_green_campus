import 'package:flutter/material.dart';

import '../../../../data/models/data_models.dart';
import 'quiz_card.dart';

class CustomQuizListView extends StatelessWidget {
  const CustomQuizListView({
    super.key,
    required this.list,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      padding: const EdgeInsets.symmetric(vertical: 20),
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return QuizCard(
          index: index,
          quizModel: list[index] as QuizModel,
        );
      },
    );
  }

  final List<dynamic> list;
  final Widget? child;
}