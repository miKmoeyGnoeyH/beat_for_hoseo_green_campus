import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../global/beat/crown_gold.dart';
import '../../global/widgets/texts/custom_title_large.dart';

class VoteResult1stTitle extends StatelessWidget {
  const VoteResult1stTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CrownGold(),
        CustomTitleLarge(
          text: context.tr('1st'),
        )
      ],
    );
  }
}