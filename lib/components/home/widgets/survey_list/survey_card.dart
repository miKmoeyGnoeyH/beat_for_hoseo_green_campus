
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/models/data_models.dart';
import '../../../global/widgets/custom_rounded_bordered_container.dart';
import 'survey_card_contents.dart';

class SurveyCard extends StatelessWidget {
  const SurveyCard({
    super.key,
    required this.index,
    required this.surveyModel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        launchUrl(Uri.parse('${dotenv.env['SURVEY_URL']!}${surveyModel.surveyId}'));
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
