import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../../global/widgets/custom_rounded_bordered_container.dart';
import 'quiz_question_contents.dart';

class QuizQuestionContentsCard extends StatelessWidget {
  const QuizQuestionContentsCard({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomRoundedBorderedContainer(
      color: context.appColors.background,
      child: QuizQuestionContents(
        title: title,
        child: child,
      ),
    );
  }

  final String title;
  final Widget child;
}