import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'sign_in_text_field.dart';

class SignInSIDField extends StatelessWidget {
  SignInSIDField({
    super.key,
    required TextEditingController studentIdController,
  }) : _studentIdController = studentIdController;

  final TextEditingController _studentIdController;
  final LocalizationManager localizationManager = LocalizationManager();

  @override
  Widget build(BuildContext context) {
    return SignInTextField(
      title: localizationManager.signInSidOrId,
      hintText: localizationManager.signInSidOrIdHint,
      textEditingController: _studentIdController,
      keyboardType: TextInputType.number,
      maxLength: 8,
    );
  }
}