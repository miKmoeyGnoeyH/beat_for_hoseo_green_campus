
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../controller/register_fill_inform/register_sid_controller.dart';
import '../../global/widgets/custom_text_field.dart';

class RegisterSIDTextField extends StatelessWidget {
  const RegisterSIDTextField({
    super.key,
    required this.registerSidController,
    this.onChanged,
    this.maxLength = 8,
    this.hintText = "",
    this.inputFormatters,
    this.keyboardType,
  });

  final RegisterIDController registerSidController;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 2,
      child: CustomTextField(
        textEditingController: registerSidController.idController,
        keyboardType: keyboardType,
        hintText: hintText,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
      ),
    );
  }

  final Function(String)? onChanged;
  final String? hintText;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
}
