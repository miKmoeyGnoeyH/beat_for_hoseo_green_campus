
import 'package:Beat/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/data_models.dart';
import '../../../../managers/navigator/navigator_key_manager.dart';
import '../../../../managers/navigator/routes.dart';
import '../../../global/widgets/custom_rounded_bordered_container.dart';
import 'quest_card_contents.dart';

class QuestCard extends StatelessWidget {
  const QuestCard({
    super.key,
    required this.index,
    required this.questModel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigatorKeyManager().pushNamed(RouteNames.questDetail, arguments: questModel);
      },
      child: CustomRoundedBorderedContainer(
        color: context.appColors.background,
        borderWidth: 0.5,
        // height: context.height * 0.15,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: QuestCardContents(
            index: index,
            questModel: questModel,
          ),
        ),
      ),
    );
  }

  final int index;
  final QuestModel questModel;
}