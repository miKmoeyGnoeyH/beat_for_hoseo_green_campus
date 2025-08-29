import 'package:beat_flutter/controller/pedometer/pedometer_controller.dart';
import 'package:beat_flutter/data/models/data_models.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global/widgets/texts/custom_body_large.dart';
import '../../../global/widgets/texts/custom_label_large.dart';
import '../../../global/widgets/texts/custom_subtitle_large.dart';

class QuestCardTitleAndDesc extends StatelessWidget {
  QuestCardTitleAndDesc({
    super.key,
    required this.questModel,
    required this.index,
    // required this.eventName,
    // required this.eventType,
    // this.descriptionShort,
  });

  final LocalizationManager localizationManager = LocalizationManager();

  // final AnimationController animationController = AnimationController(vsync: this);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomLabelLarge(
            text: localizationManager
                .homeQuestNo((index + 1).toString().padLeft(2, '0')),
            textColor: context.appColors.primary,
          ),
          const SizedBox(height: 5),
          CustomSubtitleLarge(text: questModel.eventName),
          const SizedBox(height: 5),
          CustomBodyLarge(
            text: questModel.descriptionShort,
            textColor: context.appColors.onBackground.withValues(alpha: 0.5),
            maxLines: 2,
          ),
          // const SizedBox(height: 10),
        ],
      ),
    );
  }

  final QuestModel questModel;
  final int index;
// final String eventName;
// final EventType eventType;
// final String? descriptionShort;
}
