import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../controller/register_fill_inform/register_name_controller.dart';
import 'register_fill_inform_text_field.dart';

class RegisterNameTextField extends StatelessWidget {
  const RegisterNameTextField({
    super.key,
    required this.registerNameController,
    this.onChanged,
  });

  final RegisterNameController registerNameController;

  @override
  Widget build(BuildContext context) {
    return RegisterFillInformTextField(
      textEditingController: registerNameController.nameController,
      titleText: context.tr('register_name'),
      hintText: context.tr("register_name_hint"),
      onChanged: onChanged,
    );
  }

  final Function(String)? onChanged;
}