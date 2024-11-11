import 'package:flutter/material.dart';

import '../../../global/beat/neuro.dart';
import '../../../global/widgets/texts/custom_subtitle_large.dart';

class QuestCardIconAndNeuro extends StatelessWidget {
  const QuestCardIconAndNeuro({
    super.key,
    required this.neuro,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Neuro(),
          const SizedBox(height: 5),
          CustomSubtitleLarge(
            text: neuro,
            textColor: textColor,
          ),
        ],
      ),
    );
  }

  final String neuro;
  final Color? textColor;
}