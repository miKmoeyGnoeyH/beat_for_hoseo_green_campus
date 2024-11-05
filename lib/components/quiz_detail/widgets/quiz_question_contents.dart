import 'package:flutter/material.dart';

import '../../global/widgets/texts/custom_subtitle_large.dart';

class QuizQuestionContents extends StatelessWidget {
  const QuizQuestionContents({
    super.key,
    this.title,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSubtitleLarge(text: title),
          const SizedBox(height: 5),
          child ?? const SizedBox(),
        ],
      ),
    );
  }

  final String? title;
  final Widget? child;
}