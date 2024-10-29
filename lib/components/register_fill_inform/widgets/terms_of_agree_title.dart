import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../controller/register_fill_inform/register_agreement_controller.dart';
import '../../global/widgets/texts/custom_subtitle_large.dart';
import 'bottom_sheet.dart';

class TermsOfAgreementTitle extends StatelessWidget {
  const TermsOfAgreementTitle({
    super.key,
    required this.registerAgreementController,
    required this.setIsAgreementChecked,
  });

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
        child: CustomSubtitleLarge(text: context.tr('terms_of_agreement')));
  }

  final RegisterAgreementController registerAgreementController;
  final Function(bool) setIsAgreementChecked;
}