import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../../theme/texts/custom_texts.dart';

class SignInTextField extends StatelessWidget {
  const SignInTextField({
    super.key,
    required this.title,
    this.hintText,
    required this.textEditingController,
    this.keyboardType,
    this.maxLength,
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
        TextField(
          controller: textEditingController,
          keyboardType: keyboardType,
          maxLength: maxLength,
          cursorColor: context.appColors.primary,
          style: CustomTexts.bodyLarge.copyWith(
            color: context.appColors.onBackground,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: CustomTexts.bodyLarge.copyWith(
              color: context.appColors.onBackground.withOpacity(0.5),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: context.appColors.onBackground.withOpacity(0.2),
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: context.appColors.primary,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  final String title;
  final String? hintText;
  final TextEditingController textEditingController;
  final TextInputType? keyboardType;
  final int? maxLength;
}