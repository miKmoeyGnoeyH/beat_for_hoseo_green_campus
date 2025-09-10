import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:flutter/material.dart';

import 'register_fill_inform_text_field.dart';

class RegisterPasswordCheckTextField extends StatelessWidget {
  RegisterPasswordCheckTextField({
    super.key,
    required this.registerPasswordCheckController,
    this.onChanged,
  });

  final TextEditingController registerPasswordCheckController;
  final LocalizationManager localizationManager = LocalizationManager();

  @override
  Widget build(BuildContext context) {
    return RegisterFillInformTextField(
      textEditingController: registerPasswordCheckController,
      titleText: localizationManager.rfiPasswordCheck,
      hintText: localizationManager.rfiPasswordCheckHint,
      onChanged: onChanged,
      obscureText: true,
    );
  }

  final Function(String)? onChanged;
}