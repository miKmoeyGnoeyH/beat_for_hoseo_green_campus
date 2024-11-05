import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../../global/widgets/texts/custom_body_large.dart';
import '../../global/widgets/texts/custom_subtitle_large.dart';

class QuizQuestionTitle extends StatelessWidget {
  const QuizQuestionTitle({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomSubtitleLarge(
          text: title,
          textColor: context.appColors.primary,
        ),
        CustomBodyLarge(
          text: body,
          textColor: context.appColors.primary,
        )
      ],
    );
  }

  final String title;
  final String body;
}