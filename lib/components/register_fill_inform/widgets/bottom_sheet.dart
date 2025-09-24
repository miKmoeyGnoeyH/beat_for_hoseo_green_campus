import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      color: context.appColors.background,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 36.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: localizationManager.rfiTermsOfAgreement,
                    style: CustomTexts.subtitleLarge
                        .copyWith(color: context.appColors.onBackground),
                  ),
                  WidgetSpan(child: Container()),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '1.',
                        style: CustomTexts.subtitleMedium
                            .copyWith(color: context.appColors.onBackground),
                      ),
                      TextSpan(
                        children: [
                          WidgetSpan(
                            child: SizedBox(width: 5.w),
                          ),
                          TextSpan(
                            text: localizationManager.rfiToaPurpose,
                            style: CustomTexts.subtitleMedium.copyWith(
                                color: context.appColors.onBackground),
                          ),
                        ],
                      ),
                    ],
                  ),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: localizationManager.rfiToaPurposeContent,
                        style: CustomTexts.bodyLarge
                            .copyWith(color: context.appColors.onBackground),
                      ),
                    ],
                  ),
                  WidgetSpan(child: Container()),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '2.',
                        style: CustomTexts.subtitleMedium
                            .copyWith(color: context.appColors.onBackground),
                      ),
                      TextSpan(
                        children: [
                          WidgetSpan(
                            child: SizedBox(width: 5.w),
                          ),
                          TextSpan(
                            text: localizationManager.rfiToaItems,
                            style: CustomTexts.subtitleMedium.copyWith(
                                color: context.appColors.onBackground),
                          ),
                        ],
                      ),
                    ],
                  ),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: localizationManager.rfiToaItemsContent,
                        style: CustomTexts.bodyLarge
                            .copyWith(color: context.appColors.onBackground),
                      ),
                    ],
                  ),
                  WidgetSpan(child: Container()),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '3.',
                        style: CustomTexts.subtitleMedium
                            .copyWith(color: context.appColors.onBackground),
                      ),
                      TextSpan(
                        children: [
                          WidgetSpan(
                            child: SizedBox(width: 5.w),
                          ),
                          TextSpan(
                            text: localizationManager.rfiToaRetention,
                            style: CustomTexts.subtitleMedium.copyWith(
                                color: context.appColors.onBackground),
                          ),
                        ],
                      ),
                    ],
                  ),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: localizationManager.rfiToaRetentionContent,
                        style: CustomTexts.bodyLarge
                            .copyWith(color: context.appColors.onBackground),
                      ),
                    ],
                  ),
                  WidgetSpan(child: Container()),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '4.',
                        style: CustomTexts.subtitleMedium
                            .copyWith(color: context.appColors.onBackground),
                      ),
                      TextSpan(
                        children: [
                          WidgetSpan(
                            child: SizedBox(width: 5.w),
                          ),
                          TextSpan(
                            text: localizationManager.rfiToaRightToRefusal,
                            style: CustomTexts.subtitleMedium.copyWith(
                                color: context.appColors.onBackground),
                          ),
                        ],
                      ),
                    ],
                  ),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: localizationManager.rfiToaRightToRefusalContent,
                        style: CustomTexts.bodyLarge
                            .copyWith(color: context.appColors.onBackground),
                      ),
                    ],
                  ),
                  WidgetSpan(child: Container()),
                  TextSpan(
                    text: localizationManager.rfiDoYouAgree,
                    style: CustomTexts.subtitleLarge
                        .copyWith(color: context.appColors.onBackground),
                  ),
                  WidgetSpan(child: Container()),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizationManager.rfiIAgree,
                  style: CustomTexts.subtitleLarge
                      .copyWith(color: context.appColors.onBackground),
                ),
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: registerAgreementProvider.isAgreementChecked,
                    activeColor: context.appColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.setIsAgreementChecked(value!);
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _StatefulBottomSheetState();
}
