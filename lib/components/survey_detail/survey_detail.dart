import 'dart:convert';
import 'dart:developer';

import 'package:beat_flutter/components/detail/detail_label_and_title.dart';
import 'package:beat_flutter/components/global/methods/custom_show_dialog.dart';
import 'package:beat_flutter/components/global/widgets/appbars/custom_empty_appbar.dart';
import 'package:beat_flutter/components/global/widgets/buttons/custom_bottom_appbar_button.dart';
import 'package:beat_flutter/components/global/widgets/buttons/custom_refresh_button.dart';
import 'package:beat_flutter/components/global/widgets/custom_circular_progress_indicator.dart';
import 'package:beat_flutter/components/survey_detail/widgets/survey_questions.dart';
import 'package:beat_flutter/controller/home/controllers/survey_detail_controller.dart';
import 'package:beat_flutter/data/models/data_models.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/navigator/navigator_key_manager.dart';
import 'package:beat_flutter/managers/navigator/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SurveyDetail extends StatelessWidget {
  SurveyDetail({super.key});

  final SurveyDetailController surveyDetailController =
      Get.find<SurveyDetailController>();
  final LocalizationManager localizationManager = LocalizationManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.surface,
      body: CustomScrollView(
        slivers: [
          const CustomEmptyAppBar(),
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              child: surveyDetailController.obx(
                  (state) {
                    log(state.toString());
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DetailLabelAndTItle(
                          labelText: localizationManager.sdSurvey,
                          title: state.title,
                        ),
                        const SizedBox(height: 20),
                        SurveyQuestions(questionList: state.questionList),
                      ],
                    );
                  },
                  onLoading: const CustomCircularProgressIndicator(),
                  onError: (state) {
                    return CustomRefreshButton(
                      onTap: () {
                        surveyDetailController.fetchSurveyDetail();
                      },
                    );
                  }),
            ),
          )
        ],
      ),
      bottomNavigationBar: Obx(
        () {
          return CustomBottomAppbarButton(
            onTap: surveyDetailController.isAnsweredEveryQuestion
                ? () => onSubmit(context)
                : () {},
            backgroundColor: surveyDetailController.isAnsweredEveryQuestion
                ? context.appColors.primary
                : context.appColors.disabled,
            text: localizationManager.sdSubmit,
          );
        },
      ),
    );
  }

  void onSubmit(BuildContext context) async {
    try {
      final http.Response response = await Get.showOverlay(
        asyncFunction: () async {
          final String requestUrl =
              "${DotEnvManager().surveyAnswer}${(surveyDetailController.state as SurveyDetailModel).surveyId}";
          log("SurveyDetail : onSubmit : requestUrl : $requestUrl");
          log("SurveyDetail : onSubmit : jsonEncode(surveyDetailController.answersToJson()) : ${jsonEncode(surveyDetailController.answersToJson())}");

          return await http
              .post(
                Uri.parse(requestUrl),
                headers: {
                  "Contgent-Type": "application/json",
                },
                body: jsonEncode(surveyDetailController.answersToJson()),
              )
              .timeout(const Duration(seconds: 5));
        },
        loadingWidget: const CustomCircularProgressIndicator(),
      );
      log("SurveyDetail : onSubmit : response.statusCode : ${response.statusCode}");
      log("SurveyDetail : onSubmit : response.body : ${response.body}");

      if (response.statusCode == 200) {
        customShowDialog(
          context: context,
          title: localizationManager.sdSubmitCompletedTitle,
          content: localizationManager.sdSubmitCompletedContent,
          onTap: () => NavigatorKeyManager()
              .pushNamedAndRemoveUntil(RouteNames.screenHolder),
        );
      } else {
        throw Exception();
      }
    } catch (e) {
      log("SurveyDetail : onSubmit : error : ${e.toString()}");
      customShowDialog(
        context: context,
        title: localizationManager.sdSubmitErrorTitle,
        content: localizationManager.sdSubmitErrorContent,
      );
    }
  }
}
