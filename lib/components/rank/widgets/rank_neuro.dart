import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../../../data/models/data_models.dart';
import '../../global/beat/neuro.dart';
import '../../global/widgets/texts/custom_title_large.dart';

class RankNeuro extends StatelessWidget {
  const RankNeuro({
    super.key,
    required this.ranking,
  });

  final RankModel ranking;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Neuro(),
        const SizedBox(width: 8),
        CustomTitleLarge(
          text: ranking.neuro.toString(),
          textColor: context.appColors.primary,
        ),
      ],
    );
  }
}