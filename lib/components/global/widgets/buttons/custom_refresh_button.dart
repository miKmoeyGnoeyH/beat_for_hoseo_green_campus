import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../texts/custom_body_large.dart';

class CustomRefreshButton extends StatelessWidget {
  CustomRefreshButton({
    super.key,
    this.onTap,
    this.text
  });

  final LocalizationManager localizationManager = LocalizationManager();

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
                Icon(
                  Icons.refresh_rounded,
                  color: context.appColors.onBackground,
                ),
                SizedBox(height: 10.w),
                CustomBodyLarge(text: text ?? localizationManager.errorsConnectionError),
              ],
            ),
          ),
        ),
      ],
    );
  }

  final Function()? onTap;
  final String? text;
}
