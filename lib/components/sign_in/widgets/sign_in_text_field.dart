import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../../../theme/texts/custom_texts.dart';
import '../../global/widgets/custom_text_field.dart';

class SignInTextField extends StatelessWidget {
  const SignInTextField({
    super.key,
    required this.title,
    this.hintText,
    this.textEditingController,
    this.keyboardType,
    this.maxLength,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: CustomTexts.titleLarge.copyWith(
            color: context.appColors.onBackground,
          ),
        ),
        CustomTextField(
          textEditingController: textEditingController,
          keyboardType: keyboardType,
          maxLength: maxLength,
          hintText: hintText,
          obscureText: obscureText,
        ),
      ],
    );
  }

  final String title;
  final String? hintText;
  final TextEditingController? textEditingController;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool obscureText;
}