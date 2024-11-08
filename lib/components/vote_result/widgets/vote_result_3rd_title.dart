import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../global/beat/crown_bronze.dart';
import '../../global/widgets/texts/custom_title_large.dart';

class VoteResult3rdTitle extends StatelessWidget {
  const VoteResult3rdTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CrownBronze(),
        CustomTitleLarge(
          text: context.tr('3rd'),
        )
      ],
    );
  }
}