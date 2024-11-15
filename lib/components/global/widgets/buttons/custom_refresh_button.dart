
import 'package:Beat/extensions/buildcontext_extension.dart';
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
        Center(
          child: GestureDetector(
            onTap: onTap,
            child: Column(
              children: [
                Icon(Icons.refresh_rounded,
                    color: context.appColors.onBackground),
                CustomBodyLarge(text: context.tr('connection_error')),
              ],
            ),
          ),
        ),
      ],
    );
  }

  final Function()? onTap;
}
