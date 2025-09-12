import 'package:flutter/material.dart';

import '../../../controller/register_fill_inform/register_agreement_controller.dart';
import 'terms_of_agree_checkbox.dart';
import 'terms_of_agree_title.dart';

class TermsOfAgreement extends StatelessWidget {
  const TermsOfAgreement({
    super.key,
    required this.registerAgreementController,
    required this.setIsAgreementChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TermsOfAgreementTitle(
            registerAgreementController:
            registerAgreementController,
            setIsAgreementChecked: setIsAgreementChecked,
          ),
        ),
        TermsOfAgreementCheckbox(
          registerAgreementController:
          registerAgreementController,
          setIsAgreementChecked: setIsAgreementChecked,
        ),
      ],
    );
  }

  final RegisterAgreementController registerAgreementController;
  final Function(bool) setIsAgreementChecked;
}