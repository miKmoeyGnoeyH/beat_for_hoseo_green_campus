import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../global/widgets/buttons/custom_label_large_button.dart';

CustomLabelLargeButton buildSignInForgotNicknameButton(BuildContext context) {
  return CustomLabelLargeButton(
    labelText: context.tr('forgot_nickname'),
  );
}

CustomLabelLargeButton buildSignInForgotSIDButton(BuildContext context) {
  return CustomLabelLargeButton(
      labelText: context.tr('forgot_sid'));
}