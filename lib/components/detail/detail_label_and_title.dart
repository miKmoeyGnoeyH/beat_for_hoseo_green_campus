import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../global/beat/neuro.dart';
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
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTitleLarge(
              text: title,
            ),
            neuro != null
                ? Row(
                    children: [
                      CustomTitleLarge(
                        text: neuro.toString(),
                        textColor: context.appColors.primary,
                      ),
                      const SizedBox(width: 5),
                      const NeuroIcon(width: 25),
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
