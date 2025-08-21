import 'package:flutter/material.dart';

import '../texts/custom_label_large.dart';

class CustomLabelLargeButton extends StatelessWidget {
  const CustomLabelLargeButton({
    super.key,
    this.labelText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomLabelLarge(
        text: labelText,
      ),
    );
  }

  final String? labelText;
  final void Function()? onTap;
}