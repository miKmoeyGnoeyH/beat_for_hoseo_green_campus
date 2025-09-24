
import 'package:beat_flutter/components/global/beat/gc_point.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../global/widgets/texts/custom_subtitle_large.dart';
import '../global/widgets/texts/custom_title_large.dart';

class DetailLabelAndTItle extends StatelessWidget {
  const DetailLabelAndTItle({
    super.key,
    this.labelText,
    this.title,
    this.neuro,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSubtitleLarge(
          text: labelText,
          textColor: context.appColors.primary,
        ),
        SizedBox(height: 5.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: CustomTitleLarge(
                text: title,
              ),
            ),
            neuro != null
                ? Row(
                    children: [
                      CustomTitleLarge(
                        text: neuro.toString(),
                        textColor: context.appColors.primary,
                      ),
                      SizedBox(width: 5.w),
                      // const Neuro(width: 25),
                      GreenCampusPoint(width: 25.w),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ],
    );
  }

  final String? labelText;
  final String? title;
  final int? neuro;
}
