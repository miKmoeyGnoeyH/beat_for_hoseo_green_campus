import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../global/methods/custom_input_formatters.dart';
import '../../global/widgets/custom_text_field.dart';
import '../../global/widgets/texts/custom_subtitle_large.dart';

class RegisterFillInformTextField extends StatelessWidget {
  const RegisterFillInformTextField({
    super.key,
    required this.textEditingController,
    this.titleText,
    this.hintText,
    this.onChanged,
    this.obscureText = false,
    this.maxLength,
    this.inputFormatter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSubtitleLarge(text: titleText),
        CustomTextField(
          textEditingController: textEditingController,
          maxLength: maxLength,
          onChanged: onChanged,
          inputFormatters: inputFormatter,
          hintText: hintText,
          obscureText: obscureText,
        ),
      ],
    );
  }

  final String? titleText;
  final String? hintText;
  final TextEditingController textEditingController;
  final Function(String)? onChanged;
  final bool obscureText;
  final int? maxLength;
  final List<FilteringTextInputFormatter>? inputFormatter;
}