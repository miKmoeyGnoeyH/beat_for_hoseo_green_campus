import 'package:beat_flutter/components/global/beat/gc_point.dart';
import 'package:flutter/material.dart';

import '../../../global/beat/neuro.dart';
import '../../../global/widgets/texts/custom_subtitle_large.dart';

class QuestCardIconAndPoint extends StatelessWidget {
  const QuestCardIconAndPoint({
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
          // const Neuro(),
          const GreenCampusPoint(),
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