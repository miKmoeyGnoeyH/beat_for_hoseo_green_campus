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
      title: context.tr('student_id'),
      hintText: context.tr("sid_hint"),
      textEditingController: _studentIdController,
      keyboardType: TextInputType.number,
      maxLength: 8,
    );
  }
}