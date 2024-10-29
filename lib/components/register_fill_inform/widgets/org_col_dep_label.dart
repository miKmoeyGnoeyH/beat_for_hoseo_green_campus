import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../../global/widgets/texts/custom_label_large.dart';

class OrgColDepLabel extends StatelessWidget {
  const OrgColDepLabel({
    super.key,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return CustomLabelLarge(
      text: text,
      textColor: context.appColors.onBackground,
    );
  }

  final String? text;
}