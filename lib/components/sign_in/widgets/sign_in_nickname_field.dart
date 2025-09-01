import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'sign_in_text_field.dart';


class SignInNicknameField extends StatelessWidget {
  SignInNicknameField({
    super.key,
    required TextEditingController nicknameController,
  }) : _nicknameController = nicknameController;

  final TextEditingController _nicknameController;

  final LocalizationManager localizationManager = LocalizationManager();

  @override
  Widget build(BuildContext context) {
    return SignInTextField(
      title: localizationManager.signInPassword,
      hintText: localizationManager.signInPasswordHint,
      textEditingController: _nicknameController,
      maxLength: 10,
      obscureText: true,
    );
  }
}