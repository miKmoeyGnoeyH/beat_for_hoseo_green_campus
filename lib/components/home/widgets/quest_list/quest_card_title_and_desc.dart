import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../../../global/widgets/texts/custom_body_large.dart';
import '../../../global/widgets/texts/custom_label_large.dart';
import '../../../global/widgets/texts/custom_subtitle_large.dart';

class QuestCardTitleAndDesc extends StatelessWidget {
  const QuestCardTitleAndDesc({
    super.key,
    required this.index,
    required this.eventName,
    this.descriptionShort,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomLabelLarge(
            text: 'Quest ${(index + 1).toString().padLeft(2, '0')}',
            textColor: context.appColors.primary,
          ),
          CustomSubtitleLarge(text: eventName),
          CustomBodyLarge(text: descriptionShort),
        ],
      ),
    );
  }

  final int index;
  final String eventName;
  final String? descriptionShort;
}