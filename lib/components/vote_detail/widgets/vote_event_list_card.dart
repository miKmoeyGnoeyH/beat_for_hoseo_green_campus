
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../data/models/data_models.dart';
import '../../global/widgets/custom_rounded_bordered_container.dart';
import '../../global/widgets/texts/custom_body_large.dart';
import '../../global/widgets/texts/custom_label_large.dart';

class VoteEventListCard extends StatelessWidget {
  const VoteEventListCard({
    required this.voteDetailModel,
    required this.index,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
    this.votedNeuro = 0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: CustomRoundedBorderedContainer(
        borderWidth: 1,
        color: context.appColors.background,
        borderColor: isSelected
            ? context.appColors.primary
            : context.appColors.borderColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomBodyLarge(
                text: voteDetailModel.bettingEventList[index].eventName,
              ),
              const SizedBox(height: 8),
              CustomLabelLarge(
                text: voteDetailModel.bettingEventList[index].descriptionShort,
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              CustomLabelLarge(
                text: votedNeuro == 0
                    ? ''
                    : context.tr(
                        'voted_neuro',
                        args: [
                          votedNeuro.toString(),
                        ],
                      ),
                textColor: context.appColors.primary,
              )
            ],
          ),
        ),
      ),
    );
  }

  final VoteDetailModel voteDetailModel;
  final int index;
  final Function()? onTap;
  final Function()? onLongPress;
  final bool isSelected;
  final int votedNeuro;
}
