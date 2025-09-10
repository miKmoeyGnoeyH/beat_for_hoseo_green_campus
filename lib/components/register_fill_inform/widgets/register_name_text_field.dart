import 'package:beat_flutter/components/global/methods/custom_input_formatters.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:flutter/material.dart';

import '../../../controller/register_fill_inform/register_name_controller.dart';
import 'register_fill_inform_text_field.dart';

class RegisterNameTextField extends StatelessWidget {
  RegisterNameTextField({
    super.key,
    required this.registerNameController,
    this.onChanged,
  });

  final RegisterNameController registerNameController;
  final LocalizationManager localizationManager = LocalizationManager();

  @override
  Widget build(BuildContext context) {
    return RegisterFillInformTextField(
      textEditingController: registerNameController.nameController,
      titleText: localizationManager.rfiName,
      hintText: localizationManager.rfiNameHint,
      onChanged: onChanged,
      inputFormatter: [onlyEnglishAndKoreanInputFormatter()],
    );
  }

  final Function(String)? onChanged;
}