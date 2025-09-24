
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/neuro_history_model.dart';
import '../../global/widgets/custom_rounded_bordered_container.dart';
import '../../home/widgets/quest_list/quest_card_icon_and_neuro.dart';
import 'neuro_history_contents_desc.dart';

class NeuroHistoryCard extends StatelessWidget {
  const NeuroHistoryCard(
    this.neuroHistory, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomRoundedBorderedContainer(
      color: context.appColors.background,
      borderWidth: 0.5,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
        child: Row(
          children: [
            NeuroHistoryContentsDesc(
              type: neuroHistory.type,
              historyName: neuroHistory.historyName,
              checkTime: DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.parse(neuroHistory.checkTime)),
            ),
            SizedBox(width: 16.w),
            QuestCardIconAndPoint(
              neuro: neuroHistory.neuro >= 0
                  ? '+${neuroHistory.neuro.toString()}'
                  : neuroHistory.neuro.toString(),
              textColor: neuroHistory.neuro >= 0
                  ? Colors.redAccent
                  : Colors.blueAccent,
            )
          ],
        ),
      ),
    );
  }

  final NeuroHistoryModel neuroHistory;
}
