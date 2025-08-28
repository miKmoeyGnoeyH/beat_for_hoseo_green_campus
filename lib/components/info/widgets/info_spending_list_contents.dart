import 'package:flutter/material.dart';

import '../../../data/models/data_models.dart';
import '../../global/widgets/texts/custom_body_large.dart';
import '../../global/widgets/texts/custom_subtitle_large.dart';

class InfoSpendingListContents extends StatelessWidget {
  const InfoSpendingListContents(
      this.infoModel, {
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSubtitleLarge(
          text: infoModel != null ? infoModel!.event : '',
        ),
        CustomBodyLarge(
          text: infoModel != null ? infoModel!.location : '',
        ),
        CustomBodyLarge(
          // text: infoModel != null ? '${infoModel!.neuro_points} Neuro' : '',
          text: infoModel != null ? '${infoModel!.neuro_points} Points' : '',
          textColor: Colors.blueAccent,
        )
      ],
    );
  }

  final InfoModel? infoModel;
}