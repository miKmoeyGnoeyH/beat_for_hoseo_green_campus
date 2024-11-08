import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../texts/custom_body_large.dart';

class CustomRefreshButton extends StatelessWidget {
  const CustomRefreshButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Column(
            children: [
              const Icon(Icons.refresh_rounded),
              CustomBodyLarge(text: context.tr('connection_error')),
            ],
          ),
        ),
      ],
    );
  }

  final Function()? onTap;
}