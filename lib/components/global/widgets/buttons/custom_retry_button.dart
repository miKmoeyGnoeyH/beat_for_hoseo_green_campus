
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'custom_wide_button.dart';

class CustomRetryButton extends StatelessWidget {
  const CustomRetryButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(context.tr('connection_error')),
          CustomWideButton(
            onTap: onTap,
            buttonText: context.tr('retry'),
            buttonColor: context.appColors.primary,
          ),
        ],
      ),
    );
  }

  final Function()? onTap;
}