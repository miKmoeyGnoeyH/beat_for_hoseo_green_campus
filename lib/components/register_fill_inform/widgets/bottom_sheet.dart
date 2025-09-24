import 'package:beat_flutter/components/global/widgets/texts/custom_body_large.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_subtitle_large.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_subtitle_medium.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/register_fill_inform/register_agreement_controller.dart';
import '../../../theme/texts/custom_texts.dart';
import '../../global/widgets/custom_rounded_bordered_container.dart';

class StatefulBottomSheet extends StatefulWidget {
  const StatefulBottomSheet(
      {super.key,
      required this.registerAgreementProvider,
      required this.setIsAgreementChecked});

  final RegisterAgreementController registerAgreementProvider;
  final Function(bool) setIsAgreementChecked;

  @override
  State<StatefulBottomSheet> createState() => _StatefulBottomSheetState();
}

class _StatefulBottomSheetState extends State<StatefulBottomSheet> {
  RegisterAgreementController get registerAgreementProvider =>
      widget.registerAgreementProvider;

  final LocalizationManager localizationManager = LocalizationManager();

  // TODO: 전부 Text로 바꾸기
  @override
  Widget build(BuildContext context) {
    return CustomRoundedBorderedContainer(
      borderWidth: 0.5,
      borderTop: true,
      radiusTopRight: true,
      radiusTopLeft: true,
      width: double.infinity,
      height: 600.w,
      color: context.appColors.background,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 36.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomSubtitleLarge(text: localizationManager.rfiTermsOfAgreement),
              SizedBox(height: 20.w),
              CustomSubtitleMedium(text: "1. ${localizationManager.rfiToaPurpose}"),
              CustomBodyLarge(text: localizationManager.rfiToaPurposeContent),
              SizedBox(height: 16.w),
              CustomSubtitleMedium(text: "2. ${localizationManager.rfiToaItems}"),
              CustomBodyLarge(text: localizationManager.rfiToaItemsContent),
              SizedBox(height: 16.w),
              CustomSubtitleMedium(text: "3. ${localizationManager.rfiToaRetention}"),
              CustomBodyLarge(text: localizationManager.rfiToaRetentionContent),
              SizedBox(height: 16.w),
              CustomSubtitleMedium(text: "4. ${localizationManager.rfiToaRightToRefusal}"),
              CustomBodyLarge(text: localizationManager.rfiToaRightToRefusalContent),
              SizedBox(height: 16.w),
              CustomSubtitleMedium(text: localizationManager.rfiDoYouAgree),
              SizedBox(height: 20.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomSubtitleLarge(
                    text: localizationManager.rfiIAgree,
                  ),
                  Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      value: registerAgreementProvider.isAgreementChecked,
                      activeColor: context.appColors.primary,
                      checkColor: context.appColors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onChanged: (value) {
                        setState(() {
                          widget.setIsAgreementChecked(value!);
                          Get.back();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _StatefulBottomSheetState();
}
