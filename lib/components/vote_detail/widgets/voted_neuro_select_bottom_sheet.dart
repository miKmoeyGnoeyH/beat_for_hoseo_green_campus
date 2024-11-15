
import 'package:Beat/extensions/buildcontext_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controller/user_controller.dart';
import '../../../managers/navigator/navigator_key_manager.dart';
import '../../../theme/texts/custom_texts.dart';
import '../../global/widgets/buttons/custom_wide_button.dart';
import '../../global/widgets/custom_rounded_bordered_container.dart';
import '../../global/widgets/texts/custom_subtitle_large.dart';

class VoteNeuroSelectBottomSheet extends StatefulWidget {
  const VoteNeuroSelectBottomSheet(
    this.eventName, {
    super.key,
  });

  final String eventName;

  @override
  State<VoteNeuroSelectBottomSheet> createState() =>
      _VoteNeuroSelectBottomSheetState();
}

class _VoteNeuroSelectBottomSheetState
    extends State<VoteNeuroSelectBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final UserController userController = context.read<UserController>();

    return CustomRoundedBorderedContainer(
      borderWidth: 0.5,
      borderTop: true,
      radiusTopLeft: true,
      radiusTopRight: true,
      width: context.width,
      color: context.appColors.background,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
              TextSpan(
                children: [
                  if (context.deviceLocale.toString() != "ko_KR")
                    TextSpan(
                      text: context.tr('vote_to'),
                      style: CustomTexts.titleLarge
                          .copyWith(color: context.appColors.onBackground),
                    ),
                  TextSpan(
                    text: widget.eventName,
                    style: CustomTexts.titleLarge
                        .copyWith(color: context.appColors.primary),
                  ),
                  if (context.deviceLocale.toString() == "ko_KR")
                    TextSpan(
                      text: context.tr('vote_to'),
                      style: CustomTexts.titleLarge
                          .copyWith(color: context.appColors.onBackground),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text.rich(
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
              TextSpan(
                children: [
                  TextSpan(
                    text: '${context.tr('neuroes_in_hand')} ',
                    style: CustomTexts.subtitleLarge
                        .copyWith(color: context.appColors.onBackground),
                  ),
                  TextSpan(
                    text: userController.state.neuroesInHand,
                    style: CustomTexts.subtitleLarge
                        .copyWith(color: context.appColors.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            CustomRoundedBorderedContainer(
              borderWidth: 0.5,
              borderRadius: 50,
              width: double.infinity,
              color: context.appColors.background,
              child: Row(
                children: [
                  for (int i = 0; i < 5; i++)
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setVotedNeuro(i, (i + 1) * 10),
                        child: CustomRoundedBorderedContainer(
                          borderColor: Colors.transparent,
                          borderRadius: 50,
                          color: i == _selectedVotedNeuroIndex
                              ? context.appColors.primary
                              : context.appColors.background,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: CustomSubtitleLarge(
                                text: ((i + 1) * 10).toString(),
                                textColor: i == _selectedVotedNeuroIndex
                                    ? context.appColors.onPrimary
                                    : context.appColors.onBackground,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
            const SizedBox(height: 16),
            CustomWideButton(
              buttonText: context.tr('vote'),
              buttonColor: context.appColors.primary,
              onTap: () {
                NavigatorKeyManager().pop(result: _votedNeuro);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void setVotedNeuro(int selectedVotedNeuroIndex, int votedNeuro) {
    setState(() {
      _selectedVotedNeuroIndex = selectedVotedNeuroIndex;
      _votedNeuro = votedNeuro;
    });
  }

  int? _votedNeuro;
  int? _selectedVotedNeuroIndex;
}
