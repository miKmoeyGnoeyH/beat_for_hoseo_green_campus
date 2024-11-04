import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../global/widgets/texts/custom_subtitle_large.dart';
import '../global/widgets/texts/custom_title_large.dart';

class DetailLabelAndTItle extends StatelessWidget {
  const DetailLabelAndTItle({
    super.key,
    this.labelText,
    this.title,
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
        CustomTitleLarge(
          text: title,
        ),
      ],
    );
  }

  final String? labelText;
  final String? title;
}