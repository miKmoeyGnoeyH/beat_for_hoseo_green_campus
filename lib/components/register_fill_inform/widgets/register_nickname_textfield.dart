import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../controller/register_fill_inform/register_nickname_controller.dart';
import '../../global/methods/custom_input_formatters.dart';
import '../../global/widgets/custom_text_field.dart';

class RegisterNicknameTextField extends StatelessWidget {
  const RegisterNicknameTextField({
    super.key,
    required this.registerNicknameController,
    this.onChanged,
  });

  final RegisterNicknameController registerNicknameController;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 2,
      child: CustomTextField(
        textEditingController: registerNicknameController.nicknameController,
        hintText: context.tr("register_nickname_hint"),
        maxLength: 10,
        inputFormatters: [onlyEnglishAndKoreanInputFormatter()],
        onChanged: onChanged,
      ),
    );
  }

  final Function(String)? onChanged;
}