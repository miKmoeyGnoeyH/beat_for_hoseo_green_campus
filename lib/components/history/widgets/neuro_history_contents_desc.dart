
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../global/widgets/texts/custom_body_large.dart';
import '../../global/widgets/texts/custom_label_large.dart';
import '../../global/widgets/texts/custom_subtitle_large.dart';

class NeuroHistoryContentsDesc extends StatelessWidget {
  const NeuroHistoryContentsDesc({
    super.key,
    required this.type,
    required this.historyName,
    required this.checkTime,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomLabelLarge(
            text: type,
            textColor: context.appColors.primary,
          ),
          SizedBox(height: 6.w),
          CustomSubtitleLarge(
            text: historyName,
            maxLines: 1,
          ),
          SizedBox(height: 6.w),
          CustomBodyLarge(
            text: checkTime,
          ),
        ],
      ),
    );
  }

  final String type;
  final String historyName;
  final String checkTime;
}