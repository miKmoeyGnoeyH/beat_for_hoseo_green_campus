import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../controller/register_fill_inform/register_sid_controller.dart';
import '../global/methods/custom_input_formatters.dart';
import '../global/widgets/custom_text_field.dart';

class RegisterSIDTextField extends StatelessWidget {
  const RegisterSIDTextField(
      {super.key, required this.registerSidController, this.onChanged});

  final RegisterSidController registerSidController;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 2,
      child: CustomTextField(
        textEditingController: registerSidController.sidController,
        keyboardType: TextInputType.number,
        hintText: context.tr("register_sid_hint"),
        maxLength: 8,
        inputFormatters: [
          onlyDigitsInputFormatter(),
        ],
        onChanged: onChanged,
      ),
    );
  }

  final Function(String)? onChanged;
}