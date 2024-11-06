import 'package:flutter/material.dart';

import '../../global/widgets/texts/custom_subtitle_large.dart';

class QuizQuestionContents extends StatelessWidget {
  const QuizQuestionContents({
    super.key,
    this.title,
    this.imageUrl,
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
          const SizedBox(height: 10),
          imageUrl != null
              ? Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                )
              : const SizedBox(),
          imageUrl != null ? const SizedBox(height: 10) : const SizedBox(),
          child ?? const SizedBox(),
        ],
      ),
    );
  }

  final String? title;
  final String? imageUrl;
  final Widget? child;
}