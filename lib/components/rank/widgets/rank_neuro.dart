
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../data/models/data_models.dart';
import '../../global/beat/neuro.dart';
import '../../global/widgets/texts/custom_title_large.dart';

class RankNeuro extends StatelessWidget {
  const RankNeuro({
    super.key,
    required this.ranking,
  });

  final RankItemModelTest ranking;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Neuro(),
        const SizedBox(width: 8),
        CustomTitleLarge(
          text: NumberFormat("###,###,###,###").format(ranking.neuro),
          textColor: context.appColors.primary,
        ),
      ],
    );
  }
}