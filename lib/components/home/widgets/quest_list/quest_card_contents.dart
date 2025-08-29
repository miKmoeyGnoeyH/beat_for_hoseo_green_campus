import 'dart:developer';

import 'package:beat_flutter/components/global/widgets/buttons/custom_text_button.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_body_large.dart';
import 'package:beat_flutter/controller/pedometer/pedometer_controller.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/data_models.dart';
import 'quest_card_icon_and_neuro.dart';
import 'quest_card_title_and_desc.dart';

class QuestCardContents extends StatelessWidget {
  QuestCardContents({
    super.key,
    required this.index,
    required this.questModel,
  });

  final PedometerController pedometerController =
      Get.find<PedometerController>();

  final LocalizationManager localizationManager = LocalizationManager();

  @override
  Widget build(BuildContext context) {
    // 보상 수령 가능 조건 달성 여부 확인
    // 해당 퀘스트가 QR 퀘스트인 경우
    if (questModel.eventType == EventType.qr) {
      final QuestQRModel questQRModel = questModel as QuestQRModel;
      isQuestRequirementSatisfied =
          questQRModel.successCount >= questQRModel.requiredCount;
      // 해당 퀘스트가 걸음 수 퀘스트인 경우
    } else {
      isQuestRequirementSatisfied = false;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            QuestCardTitleAndDesc(
              questModel: questModel,
              index: index,
              // eventName: questModel.eventName,
              // eventType: questModel.eventType,
              // descriptionShort: questModel.descriptionShort,
            ),
            const SizedBox(width: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: QuestCardIconAndPoint(neuro: questModel.neuro.toString()),
            ),
          ],
        ),
        questModel.eventType == EventType.qr
            ? Row(
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomBodyLarge(
                          text:
                              "${(questModel as QuestQRModel).successCount} / ${(questModel as QuestQRModel).totalCount}",
                          textColor: context.appColors.disabled,
                        ),
                        const SizedBox(height: 5),
                        LinearProgressIndicator(
                          color: context.appColors.primary,
                          backgroundColor: context.appColors.disabled,
                          borderRadius: BorderRadius.circular(50),
                          value: ((questModel as QuestQRModel).successCount) /
                              ((questModel as QuestQRModel).totalCount),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  questModel.hasSuccess
                      ? CustomTextButton(
                          text: localizationManager.homeClaimed,
                          buttonColor: context.appColors.disabled,
                          borderRadius: 5,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                        )
                      : CustomTextButton(
                          text: localizationManager.homeClaim,
                          buttonColor: isQuestRequirementSatisfied
                              ? context.appColors.primary
                              : context.appColors.disabled,
                          borderRadius: 5,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          onTap: onClaimButtonTap,
                        ),
                ],
              )
            : Obx(
                () {
                  final QuestWalkModel questWalkModel =
                      questModel as QuestWalkModel;

                  // 해당 퀘스트가 일일 퀘스트인 경우
                  if (questWalkModel.eventPeriodType == EventPeriodType.daily) {
                    isQuestRequirementSatisfied = pedometerController.steps >=
                        questWalkModel.requiredWalkCount;
                    // 해당 퀘스트가 주간 퀘스트인 경우
                  } else if (questWalkModel.eventPeriodType ==
                      EventPeriodType.weekly) {
                    isQuestRequirementSatisfied =
                        pedometerController.weeklyWalkCount >=
                            questWalkModel.requiredWalkCount;
                    // 해당 퀘스트가 월간 퀘스트인 경우
                  } else if (questWalkModel.eventPeriodType ==
                      EventPeriodType.monthly) {
                    isQuestRequirementSatisfied =
                        pedometerController.monthlyWalkCount >=
                            questWalkModel.requiredWalkCount;
                    // 그 외
                  } else {
                    isQuestRequirementSatisfied = false;
                  }

                  int steps;
                  if ((questModel as QuestWalkModel).eventPeriodType ==
                      EventPeriodType.daily)
                    steps = pedometerController.steps;
                  else if ((questModel as QuestWalkModel).eventPeriodType ==
                      EventPeriodType.weekly)
                    steps = pedometerController.weeklyWalkCount;
                  else if ((questModel as QuestWalkModel).eventPeriodType ==
                      EventPeriodType.monthly)
                    steps = pedometerController.monthlyWalkCount;
                  else
                    steps = 0;

                  return Row(
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomBodyLarge(
                              text:
                                  "$steps / ${(questModel as QuestWalkModel).requiredWalkCount}",
                              textColor: context.appColors.disabled,
                            ),
                            const SizedBox(height: 5),
                            LinearProgressIndicator(
                              color: context.appColors.primary,
                              backgroundColor: context.appColors.disabled,
                              borderRadius: BorderRadius.circular(50),
                              value: steps /
                                  ((questModel as QuestWalkModel)
                                      .requiredWalkCount),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      questModel.hasSuccess
                          ? CustomTextButton(
                              text: localizationManager.homeClaimed,
                              buttonColor: context.appColors.disabled,
                              borderRadius: 5,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                            )
                          : CustomTextButton(
                              text: localizationManager.homeClaim,
                              buttonColor: isQuestRequirementSatisfied
                                  ? context.appColors.primary
                                  : context.appColors.disabled,
                              borderRadius: 5,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              onTap: onClaimButtonTap,
                            ),
                    ],
                  );
                },
              )
      ],
    );
  }

  void onClaimButtonTap() {
    log("onClaimButtonTap");
  }

  bool isQuestRequirementSatisfied = false;

  final int index;
  final QuestModel questModel;
}
