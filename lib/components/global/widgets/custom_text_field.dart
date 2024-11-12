import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../theme/texts/custom_texts.dart';
import '../methods/custom_textfield_decoration.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.textEditingController,
    this.keyboardType,
    this.maxLength,
    this.hintText,
    this.onChanged,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: context.appColors.primary,
          selectionColor: context.appColors.primary,
          selectionHandleColor: context.appColors.primary,
        ),
      ),
      child: TextField(
        controller: textEditingController,
        keyboardType: keyboardType,
        maxLength: maxLength,
        cursorColor: context.appColors.primary,
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        style: CustomTexts.bodyLarge.copyWith(
          color: context.appColors.onBackground,
        ),
        decoration: buildCustomInputDecoration(context, hintText),
      ),
    );
  }

  final TextEditingController? textEditingController;
  final TextInputType? keyboardType;
  final int? maxLength;
  final String? hintText;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
}
