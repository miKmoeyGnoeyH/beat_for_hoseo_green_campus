import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
