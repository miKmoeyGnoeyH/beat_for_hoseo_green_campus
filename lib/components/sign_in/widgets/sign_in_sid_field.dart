import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'sign_in_text_field.dart';

class SignInSIDField extends StatelessWidget {
  const SignInSIDField({
    super.key,
    required TextEditingController studentIdController,
  }) : _studentIdController = studentIdController;

  final TextEditingController _studentIdController;

  @override
  Widget build(BuildContext context) {
    return SignInTextField(
      title: context.tr('sign_in_sid_or_id'),
      hintText: context.tr("sign_in_id_hint"),
      textEditingController: _studentIdController,
      keyboardType: TextInputType.number,
      maxLength: 8,
    );
  }
}