import 'package:beat_flutter/components/global/widgets/custom_rounded_bordered_container.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_body_large.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_subtitle_large.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_title_medium.dart';
import 'package:beat_flutter/controller/home/controllers/survey_detail_controller.dart';
import 'package:beat_flutter/data/models/data_models.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SurveyQuestion extends StatefulWidget {
  const SurveyQuestion({
    super.key,
    required this.index,
    required this.surveyQuestionModel,
  });

  final int index;
  final SurveyQuestionModel surveyQuestionModel;

  @override
  State<SurveyQuestion> createState() => _SurveyQuestionState();
}

class _SurveyQuestionState extends State<SurveyQuestion> {
  final SurveyDetailController surveyDetailController = Get.find<SurveyDetailController>();
  final LocalizationManager localizationManager = LocalizationManager();
  int? selectedAnswerIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSubtitleLarge(
          text: localizationManager.sdQuestion("${widget.index + 1}".padLeft(2, "0")),
          textColor: context.appColors.primary,
        ),
        SizedBox(height: 8.w),
        CustomRoundedBorderedContainer(
          color: Colors.transparent,
          borderWidth: 0.5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTitleMedium(text: widget.surveyQuestionModel.question),
                SizedBox(height: 16.w),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => onAnswerTap(index),
                      child: CustomRoundedBorderedContainer(
                        borderWidth: 0.3,
                        borderRadius: 10,
                        color: selectedAnswerIndex == index
                            ? context.appColors.primary
                            : Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: CustomBodyLarge(
                            text: widget.surveyQuestionModel.answerList[index]
                                .description,
                            textColor: selectedAnswerIndex == index
                                ? context.appColors.onPrimary : context.appColors.onBackground,
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemCount: widget.surveyQuestionModel.answerList.length,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  void onAnswerTap(int index) {
    setState(() {
      selectedAnswerIndex = index;
      widget.surveyQuestionModel.selectedAnswerIndex = index;
      surveyDetailController.updateIsAnsweredEveryQuestion();
    });
  }
}
