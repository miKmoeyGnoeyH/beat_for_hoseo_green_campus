import 'package:beat_flutter/components/global/beat/gc_point.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_subtitle_large.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          GreenCampusPoint(width: 25.w),
          SizedBox(height: 5.w),
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
