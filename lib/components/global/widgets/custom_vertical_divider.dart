import 'package:Beat/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

class CustomVerticalDivider extends StatelessWidget {
  const CustomVerticalDivider({
    super.key,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: 1,
        height: height,
        color:
        context.appColors.onBackground.withOpacity(0.5),
      ),
    );
  }

  final double height;
}