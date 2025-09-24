import 'package:beat_flutter/components/global/widgets/texts/custom_body_large.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/models/data_models.dart';
import 'survey_card.dart';

class CustomSurveyListView extends StatelessWidget {
  CustomSurveyListView({
    super.key,
    required this.list,
    this.child,
  });

  final LocalizationManager localizationManager = LocalizationManager();

  @override
  Widget build(BuildContext context) {
    return list.isNotEmpty
        ? ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            padding: EdgeInsets.symmetric(vertical: 20.w),
            separatorBuilder: (context, index) => SizedBox(height: 24.w),
            itemBuilder: (context, index) {
              return SurveyCard(
                index: index,
                surveyModel: list[index] as SurveyModel,
              );
            },
          )
        : SizedBox(
          height: 300.w,
          width: double.infinity,
          child: Center(
            child: CustomBodyLarge(
              text: localizationManager.homeNoSurvey,
              textColor: context.appColors.borderColor,
            ),
          ),
        );
  }

  final List<dynamic> list;
  final Widget? child;
}
