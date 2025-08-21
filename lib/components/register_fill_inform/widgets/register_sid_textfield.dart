
import 'package:flutter/material.dart';

import '../../../controller/register_fill_inform/register_sid_controller.dart';
import '../../global/methods/custom_input_formatters.dart';
import '../../global/widgets/custom_text_field.dart';

class RegisterSIDTextField extends StatelessWidget {
  const RegisterSIDTextField({
    super.key,
    required this.registerSidController,
    this.onChanged,
    this.hintText = "",
  });

  final RegisterIDController registerSidController;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 2,
      child: CustomTextField(
        textEditingController: registerSidController.idController,
        keyboardType: TextInputType.number,
        hintText: hintText,
        maxLength: 8,
        inputFormatters: [
          onlyDigitsInputFormatter(),
        ],
        onChanged: onChanged,
      ),
    );
  }

  final Function(String)? onChanged;
  final String? hintText;
}
