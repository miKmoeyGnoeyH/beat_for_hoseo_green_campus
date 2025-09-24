
import 'package:beat_flutter/components/global/widgets/texts/custom_title_large.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../global/widgets/custom_rounded_bordered_container.dart';
import '../global/widgets/texts/custom_body_large.dart';

class DetailDesc extends StatelessWidget {
  DetailDesc({
    super.key,
    required this.description,
  });

  final LocalizationManager localizationManager = LocalizationManager();

  @override
  Widget build(BuildContext context) {
    return CustomRoundedBorderedContainer(
      width: double.infinity,
      borderWidth: 0.5,
      color: context.appColors.background,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTitleLarge(text: localizationManager.qdDescription),
            SizedBox(height: 10.w),
            CustomBodyLarge(text: description),
          ],
        ),
      ),
    );
  }

  final String description;
}
