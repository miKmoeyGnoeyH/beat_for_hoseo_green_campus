import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../../../theme/texts/custom_texts.dart';
import '../../global/widgets/appbars/custom_appbar.dart';

class RegisterBasicAppbar extends StatelessWidget {
  const RegisterBasicAppbar({
    super.key,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: Text(
        text ?? '',
        style: CustomTexts.displaySmall,
      ),
      iconTheme: IconThemeData(
        color: context.appColors.primary,
      ),
    );
  }

  final String? text;
}
