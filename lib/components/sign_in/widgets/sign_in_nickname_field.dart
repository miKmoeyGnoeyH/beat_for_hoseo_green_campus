import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'sign_in_text_field.dart';


class SignInNicknameField extends StatelessWidget {
  const SignInNicknameField({
    super.key,
    required TextEditingController nicknameController,
  }) : _nicknameController = nicknameController;

  final TextEditingController _nicknameController;

  @override
  Widget build(BuildContext context) {
    return SignInTextField(
      title: context.tr('nickname'),
      hintText: context.tr("nickname_hint"),
      textEditingController: _nicknameController,
      maxLength: 10,
    );
  }
}