import 'package:flutter/material.dart';

import '../appbars/custom_bottom_appbar.dart';

class CustomBottomAppbarButton extends StatelessWidget {
  const CustomBottomAppbarButton({
    super.key,
    this.onTap,
    this.backgroundColor,
    this.text,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomBottomAppbar(
        backgroundColor: backgroundColor,
        text: text,
        textColor: textColor,
      ),
    );
  }

  final Function()? onTap;
  final Color? backgroundColor;
  final String? text;
  final Color? textColor;
}