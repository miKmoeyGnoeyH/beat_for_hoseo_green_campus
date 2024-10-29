import 'package:flutter/material.dart';

import '../texts/custom_label_large.dart';

class CustomLabelLargeButton extends StatelessWidget {
  const CustomLabelLargeButton({
    super.key,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: CustomLabelLarge(
        text: labelText,
      ),
    );
  }

  final String? labelText;
}