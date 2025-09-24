import 'package:auto_size_text/auto_size_text.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/theme/texts/custom_texts.dart';
import 'package:flutter/material.dart';

import '../../../controller/register_fill_inform/register_agreement_controller.dart';
import 'bottom_sheet.dart';

class TermsOfAgreementTitle extends StatelessWidget {
  TermsOfAgreementTitle({
    super.key,
    required this.registerAgreementController,
    required this.setIsAgreementChecked,
  });

  final LocalizationManager localizationManager = LocalizationManager();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) => StatefulBottomSheet(
                  registerAgreementProvider: registerAgreementController,
                  setIsAgreementChecked: setIsAgreementChecked,
                ));
      },
      child: AutoSizeText(
        localizationManager.rfiTermsOfAgreement,
        style: CustomLargeTexts.subtitleLarge.copyWith(
          color: context.appColors.onBackground,
        ),
        maxLines: 1,
      ),
    );
  }

  final RegisterAgreementController registerAgreementController;
  final Function(bool) setIsAgreementChecked;
}
