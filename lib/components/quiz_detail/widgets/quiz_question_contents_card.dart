
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../../global/widgets/custom_rounded_bordered_container.dart';
import 'quiz_question_contents.dart';

class QuizQuestionContentsCard extends StatelessWidget {
  const QuizQuestionContentsCard({
    super.key,
    required this.title,
    this.imageUrl,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomRoundedBorderedContainer(
      borderWidth: 0.5,
      color: context.appColors.background,
      child: QuizQuestionContents(
        title: title,
        imageUrl: imageUrl,
        child: child,
      ),
    );
  }

  final String title;
  final String? imageUrl;
  final Widget child;
}