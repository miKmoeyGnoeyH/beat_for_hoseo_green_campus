
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:flutter/material.dart';

import '../../../global/widgets/texts/custom_body_large.dart';
import '../../../global/widgets/texts/custom_label_large.dart';
import '../../../global/widgets/texts/custom_subtitle_large.dart';

class QuizCardTitleAndDesc extends StatelessWidget {
  QuizCardTitleAndDesc({
    super.key,
    required this.index,
    required this.title,
    this.content,
  });

  final LocalizationManager localizationManager = LocalizationManager();

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomLabelLarge(
            text: localizationManager.homeQuizNo((index + 1).toString().padLeft(2, '0')),
            textColor: context.appColors.primary,
          ),
          const SizedBox(height: 5),
          CustomSubtitleLarge(text: title),
          const SizedBox(height: 5),
          CustomBodyLarge(
              text: content,
              textColor: context.appColors.onBackground.withOpacity(0.5),
              maxLines: 2),
        ],
      ),
    );
  }

  final int index;
  final String title;
  final String? content;
}
