import 'package:beat_flutter/components/global/beat/gc_point.dart';
import 'package:flutter/material.dart';

import '../../../global/beat/neuro.dart';
import '../../../global/widgets/texts/custom_subtitle_large.dart';

class QuizCardIconAndPoint extends StatelessWidget {
  const QuizCardIconAndPoint({
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
            // const Neuro(),
            const GreenCampusPoint(),
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