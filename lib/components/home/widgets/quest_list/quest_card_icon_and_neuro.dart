import 'package:flutter/material.dart';

import '../../../global/beat/beat_coin.dart';
import '../../../global/widgets/texts/custom_subtitle_large.dart';

class QuestCardIconAndNeuro extends StatelessWidget {
  const QuestCardIconAndNeuro({
    super.key,
    required this.neuro,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const BeatCoin(),
            const SizedBox(height: 5),
            CustomSubtitleLarge(
              text: neuro.toString(),
            ),
          ],
        ),
      ),
    );
  }

  final int neuro;
}