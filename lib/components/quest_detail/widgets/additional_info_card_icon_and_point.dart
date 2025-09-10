import 'package:beat_flutter/components/global/beat/gc_point.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_subtitle_large.dart';
import 'package:flutter/material.dart';

class AdditionalInfoCardIconAndPoint extends StatelessWidget {
  const AdditionalInfoCardIconAndPoint({
    super.key,
    required this.point,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // const Neuro(),
          const GreenCampusPoint(width: 25),
          const SizedBox(height: 5),
          CustomSubtitleLarge(
            text: point,
            textColor: textColor,
          ),
        ],
      ),
    );
  }

  final String point;
  final Color? textColor;
}
