import 'package:flutter/material.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSubtitleLarge(text: titleText),
        CustomTextField(
          textEditingController: textEditingController,
          maxLength: 6,
          onChanged: onChanged,
          inputFormatters: [onlyEnglishAndKoreanInputFormatter()],
          hintText: hintText,
        ),
      ],
    );
  }

  final String? titleText;
  final String? hintText;
  final TextEditingController textEditingController;
  final Function(String)? onChanged;
}