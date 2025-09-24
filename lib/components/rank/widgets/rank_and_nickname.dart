import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/data_models.dart';
import '../../global/beat/crown_bronze.dart';
import '../../global/beat/crown_gold.dart';
import '../../global/beat/crown_silver.dart';
import '../../global/widgets/texts/custom_body_large.dart';
import '../../global/widgets/texts/custom_title_large.dart';

class RankAndNickname extends StatelessWidget {
  const RankAndNickname({
    super.key,
    required this.rank,
    required this.ranking,
  });

  final int rank;
  final RankItemModel ranking;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (rank == 1)
          const CrownGold()
        else if (rank == 2)
          const CrownSilver()
        else if (rank == 3)
            const CrownBronze()
          else
            Padding(
              padding: EdgeInsets.only(left: 10.w, right: 8.w),
              child: CustomTitleLarge(
                text: rank.toString(),
              ),
            ),
        SizedBox(width: 16.w),
        CustomBodyLarge(
          text: ranking.nickname,
        )
      ],
    );
  }
}