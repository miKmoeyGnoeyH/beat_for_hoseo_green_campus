import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../../../theme/texts/custom_texts.dart';

InputDecoration buildCustomInputDecoration(BuildContext context, String? hintText) {
  return InputDecoration(
    counterText: "",
    hintText: hintText,
    hintStyle: CustomTexts.bodyLarge.copyWith(
      color: context.appColors.onBackground.withOpacity(0.5),
    ),
    enabledBorder: buildCustomEnabledBorder(context),
    focusedBorder: buildCustomFocusedBorder(context),
  );
}

UnderlineInputBorder buildCustomFocusedBorder(BuildContext context) {
  return UnderlineInputBorder(
    borderSide: BorderSide(
      color: context.appColors.primary,
      width: 1,
    ),
  );
}

UnderlineInputBorder buildCustomEnabledBorder(BuildContext context) {
  return UnderlineInputBorder(
    borderSide: BorderSide(
      color: context.appColors.borderColor,
    ),
  );
}