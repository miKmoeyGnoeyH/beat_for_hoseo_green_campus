
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/data_models.dart';
import '../../../../managers/navigator/navigator_key_manager.dart';
import '../../../../managers/navigator/routes.dart';
import '../../../global/widgets/custom_rounded_bordered_container.dart';
import 'quiz_card_contents.dart';

class QuizCard extends StatelessWidget {
  const QuizCard({
    super.key,
    required this.index,
    required this.quizModel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigatorKeyManager().pushNamed(RouteNames.quizDetail, arguments: quizModel);
      },
      child: CustomRoundedBorderedContainer(
        color: context.appColors.background,
        borderWidth: 0.5,
        // height: context.height * 0.12,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: QuizCardContents(
            index: index,
            quizModel: quizModel,
          ),
        ),
      ),
    );
  }

  final int index;
  final QuizModel quizModel;
}