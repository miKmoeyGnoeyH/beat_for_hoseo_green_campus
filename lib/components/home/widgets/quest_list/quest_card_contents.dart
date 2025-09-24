import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:beat_flutter/components/global/methods/custom_show_dialog.dart';
import 'package:beat_flutter/components/global/widgets/buttons/custom_text_button.dart';
import 'package:beat_flutter/components/global/widgets/custom_circular_progress_indicator.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_body_large.dart';
import 'package:beat_flutter/controller/home/controllers/quest_list_controller.dart';
import 'package:beat_flutter/controller/home/controllers/survey_detail_controller.dart';
import 'package:beat_flutter/controller/home/events/data_events.dart';
import 'package:beat_flutter/controller/pedometer/pedometer_controller.dart';
import 'package:beat_flutter/controller/user_controller.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/logger/beat_logger.dart';
import 'package:beat_flutter/managers/navigator/navigator_key_manager.dart';
import 'package:beat_flutter/managers/navigator/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../data/models/data_models.dart';
import 'quest_card_icon_and_neuro.dart';
import 'quest_card_title_and_desc.dart';

class QuestCardContents extends StatefulWidget {
  const QuestCardContents({
    super.key,
    required this.index,
    required this.questModel,
  });

  @override
  State<QuestCardContents> createState() => _QuestCardContentsState();

  final int index;
  final QuestModel questModel;
}

class _QuestCardContentsState extends State<QuestCardContents> {
  final PedometerController pedometerController =
      Get.find<PedometerController>();

  final LocalizationManager localizationManager = LocalizationManager();

  @override
  Widget build(BuildContext context) {
    final UserController userController = context.read<UserController>();
    final QuestListController questListController =
        context.read<QuestListController>();

    // 보상 수령 가능 조건 달성 여부 확인
    // 해당 퀘스트가 QR 퀘스트인 경우
    if (widget.questModel.eventType == EventType.qr) {
      final QuestQRModel questQRModel = widget.questModel as QuestQRModel;
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
              questModel: widget.questModel,
              index: widget.index,
              // eventName: questModel.eventName,
              // eventType: questModel.eventType,
              // descriptionShort: questModel.descriptionShort,
            ),
            // const SizedBox(width: 30),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: QuestCardIconAndPoint(
                neuro: widget.questModel.neuro.toString(),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.w),
        widget.questModel.eventType == EventType.qr
            ? Row(
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomBodyLarge(
                          text:
                              "${(widget.questModel as QuestQRModel).successCount} / ${(widget.questModel as QuestQRModel).totalCount}",
                          textColor: context.appColors.disabled,
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          color: context.appColors.primary,
                          backgroundColor: context.appColors.disabled,
                          borderRadius: BorderRadius.circular(50),
                          value: ((widget.questModel as QuestQRModel)
                                  .successCount) /
                              ((widget.questModel as QuestQRModel).totalCount),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 15.w),
                  widget.questModel.hasSuccess
                      ? CustomTextButton(
                          text: localizationManager.homeClaimed,
                          buttonColor: context.appColors.disabled,
                          borderRadius: 5,
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 5.w,
                          ),
                        )
                      : CustomTextButton(
                          text: localizationManager.homeClaim,
                          buttonColor: isQuestRequirementSatisfied
                              ? context.appColors.primary
                              : context.appColors.disabled,
                          borderRadius: 5,
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 5.w,
                          ),
                          onTap: isQuestRequirementSatisfied
                              ? () => onClaimButtonTap(context)
                              : () {},
                        ),
                ],
              )
            : Obx(
                () {
                  final QuestWalkModel questWalkModel =
                      widget.questModel as QuestWalkModel;

                  // 해당 퀘스트가 일일 퀘스트인 경우
                  if (questWalkModel.eventPeriodType == EventPeriodType.daily) {
                    isQuestRequirementSatisfied =
                        pedometerController.todayWalkCount >=
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
                  if ((widget.questModel as QuestWalkModel).eventPeriodType ==
                      EventPeriodType.daily) {
                    steps = pedometerController.todayWalkCount;
                  } else if ((widget.questModel as QuestWalkModel)
                          .eventPeriodType ==
                      EventPeriodType.weekly) {
                    steps = pedometerController.weeklyWalkCount;
                  } else if ((widget.questModel as QuestWalkModel)
                          .eventPeriodType ==
                      EventPeriodType.monthly) {
                    steps = pedometerController.monthlyWalkCount;
                  } else {
                    steps = 0;
                  }

                  return Row(
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomBodyLarge(
                              text:
                                  "$steps / ${(widget.questModel as QuestWalkModel).requiredWalkCount}",
                              textColor: context.appColors.disabled,
                            ),
                            SizedBox(height: 10.w),
                            LinearProgressIndicator(
                              color: context.appColors.primary,
                              backgroundColor: context.appColors.disabled,
                              borderRadius: BorderRadius.circular(50),
                              value: steps /
                                  ((widget.questModel as QuestWalkModel)
                                      .requiredWalkCount),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 15.w),
                      widget.questModel.hasSuccess
                          ? CustomTextButton(
                              text: localizationManager.homeClaimed,
                              buttonColor: context.appColors.disabled,
                              borderRadius: 5,
                              padding: EdgeInsets.symmetric(
                                horizontal: 5.w,
                                vertical: 5.w,
                              ),
                            )
                          : CustomTextButton(
                              text: localizationManager.homeClaim,
                              buttonColor: isQuestRequirementSatisfied
                                  ? context.appColors.primary
                                  : context.appColors.disabled,
                              borderRadius: 5,
                              padding: EdgeInsets.symmetric(
                                horizontal: 5.w,
                                vertical: 5.w,
                              ),
                              onTap: isQuestRequirementSatisfied
                                  ? () => onClaimButtonTap(context)
                                  : () {},
                            ),
                    ],
                  );
                },
              )
      ],
    );
  }

  Future<void> onClaimButtonTap(BuildContext context) async {
    final UserController userController = context.read<UserController>();

    try {
      final http.Response response = await Get.showOverlay(
          asyncFunction: () =>
              requestReward(userController.state.authorization),
          loadingWidget: const CustomCircularProgressIndicator());

      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        customShowDialog(
          context: context,
          title: localizationManager.homeRewardAcquisitionComplete,
          content: localizationManager.homeRewardAcquisitionCompleteContent,
          onTap: () {
            final Map<String, dynamic> responseBody = jsonDecode(response.body);

            final int surveyId = responseBody["surveyId"];
            BEATLogger.d("QuestCard onClaimButtonTap surveyId: $surveyId");

            if (surveyId > 0) {
              Get.find<SurveyDetailController>().surveyId = surveyId;
              Get.find<SurveyDetailController>().fetchSurveyDetail();
            }

            Get.back();
            NavigatorKeyManager().pushNamed(RouteNames.surveyDetail);
          },
        );
      } else {
        customShowDialog(
            context: context,
            title: localizationManager.homeRewardAcquisitionFailed,
            content: response.body);
      }
    } on TimeoutException {
      customShowDialog(
          context: context,
          title: localizationManager.errorsTimeout,
          content: localizationManager.errorsConnectionError);
    } catch (e) {
      log("QuestCardContents : onClaimButtonTap error : $e");
      customShowDialog(
          context: context,
          title: localizationManager.errorsUnknown,
          content: localizationManager.errorsUnknownDetail);
    } finally {
      userController.add(GetMyNeuro());
      context.read<QuestListController>().add(DataListRequest());
    }
  }

  Future<http.Response> requestReward(String authorization) async {
    log("QuestCardContents : onClaimButtonTap");
    final String authorization = pedometerController.authorization;
    final int eventId = widget.questModel.eventId;
    const bool hasSuccess = true;
    final String requestUrl = widget.questModel.eventType == EventType.qr
        ? "${DotEnvManager().questQRCheckUrl}$eventId?hasSuccess=$hasSuccess"
        : "${DotEnvManager().questWalkCheckUrl}$eventId?hasSuccess=$hasSuccess";

    return await http.get(Uri.parse(requestUrl), headers: {
      'Authorization': authorization,
    }).timeout(const Duration(seconds: 5));
  }

  bool isQuestRequirementSatisfied = false;
}
