import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../global/widgets/texts/custom_label_large.dart';

class VoteDesc extends StatelessWidget {
  const VoteDesc({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomLabelLarge(text: context.tr('vote_title')),
        CustomLabelLarge(
            text: context.tr('vote_rules', gender: 'vote_rule_1')),
        CustomLabelLarge(text: context.tr('vote_rules', gender: 'vote_rule_2')),
      ],
    );
  }
}