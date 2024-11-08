import 'package:BEAT/components/global/beat/neuro.dart';
import 'package:BEAT/components/global/widgets/texts/custom_title_large.dart';
import 'package:flutter/material.dart';

import '../../global/widgets/texts/custom_label_large.dart';
import '../../global/widgets/texts/custom_subtitle_large.dart';

class VoteCardTitleAndDesc extends StatelessWidget {
  const VoteCardTitleAndDesc({
    super.key,
    required this.index,
    required this.eventName,
    this.descriptionShort,
    this.gatheredNeuro,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSubtitleLarge(
            text: eventName,
            maxLines: 2,
          ),
          const SizedBox(height: 10),
          CustomLabelLarge(
            text: descriptionShort,
            maxLines: 2,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const NeuroIcon(),
              const SizedBox(width: 5),
              CustomTitleLarge(text: gatheredNeuro ?? '0'),
            ],
          )
        ],
      ),
    );
  }

  final int index;
  final String eventName;
  final String? descriptionShort;
  final String? gatheredNeuro;
}
