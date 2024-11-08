import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../global/beat/crown_silver.dart';
import '../../global/widgets/texts/custom_title_large.dart';

class VoteResult2ndTitle extends StatelessWidget {
  const VoteResult2ndTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CrownSilver(),
        CustomTitleLarge(
          text: context.tr('2nd'),
        )
      ],
    );
  }
}