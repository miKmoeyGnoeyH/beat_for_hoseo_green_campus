import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../controller/register_fill_inform/register_agreement_controller.dart';

class TermsOfAgreementCheckbox extends StatelessWidget {
  const TermsOfAgreementCheckbox({
    super.key,
    required this.registerAgreementController,
    required this.setIsAgreementChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.2,
      child: Checkbox(
        value: registerAgreementController.isAgreementChecked,
        activeColor: context.appColors.primary,
        checkColor: context.appColors.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onChanged: (value) {
          setIsAgreementChecked(value!);
        },
      ),
    );
  }

  final RegisterAgreementController registerAgreementController;
  final Function(bool) setIsAgreementChecked;
}