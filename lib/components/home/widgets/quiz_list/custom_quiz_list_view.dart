import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/data_models.dart';
import 'quiz_card.dart';

class CustomQuizListView extends StatelessWidget {
   CustomQuizListView({
    super.key,
    required this.list,
    this.child,
  });

   final LocalizationManager localizationManager = LocalizationManager();

  @override
  Widget build(BuildContext context) {
    return list.isEmpty ? SizedBox(
      height: 400,
      child: Center(
        child: Text(localizationManager.homeThereIsNoQuizYet),
      ),
    ) : ListView.separated(
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