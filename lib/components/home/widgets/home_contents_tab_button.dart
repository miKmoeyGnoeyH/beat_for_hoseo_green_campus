import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../global/widgets/texts/custom_subtitle_large.dart';

class HomeContentsTabButton extends StatelessWidget {
  const HomeContentsTabButton({
    super.key,
    required this.title,
    required this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: GestureDetector(
        onTap: onTap,
        child: CustomSubtitleLarge(text: title, textColor: textColor),
      ),
    );
  }

  final Function()? onTap;
  final String title;
  final Color textColor;
}
