import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../controller/register_fill_inform/register_name_controller.dart';
import 'register_fill_inform_text_field.dart';

class RegisterPasswordTextField extends StatelessWidget {
  RegisterPasswordTextField({
    super.key,
    required this.registerPasswordController,
    this.onChanged,
  });

  final TextEditingController registerPasswordController;
  final LocalizationManager localizationManager = LocalizationManager();

  @override
  Widget build(BuildContext context) {
    return RegisterFillInformTextField(
      textEditingController: registerPasswordController,
      titleText: localizationManager.rfiPassword,
      hintText: localizationManager.rfiPasswordHint,
      onChanged: onChanged,
      obscureText: true,
    );
  }

  final Function(String)? onChanged;
}