import 'package:beat_flutter/controller/home/controllers/survey_detail_controller.dart';
import 'package:beat_flutter/controller/user_controller.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/navigator/navigator_key_manager.dart';
import 'package:beat_flutter/managers/navigator/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../data/models/data_models.dart';
import '../../../global/widgets/custom_rounded_bordered_container.dart';
import 'survey_card_contents.dart';

class SurveyCard extends StatelessWidget {
  SurveyCard({
    super.key,
    required this.index,
    required this.surveyModel,
  });

  final SurveyDetailController surveyDetailController =
      Get.find<SurveyDetailController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // launchUrl(Uri.parse('${dotenv.env['SURVEY_URL']!}${surveyModel.surveyId}'));
        final UserController userController = context.read<UserController>();
        surveyDetailController.surveyId = surveyModel.surveyId;
        surveyDetailController.fetchSurveyDetail();
        NavigatorKeyManager().pushNamed(RouteNames.surveyDetail);
      },
      child: CustomRoundedBorderedContainer(
        color: context.appColors.background,
        borderWidth: 0.5,
        // height: context.height * 0.12,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: SurveyCardContents(
            index: index,
            surveyModel: surveyModel,
          ),
        ),
      ),
    );
  }

  final int index;
  final SurveyModel surveyModel;
}
