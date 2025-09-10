import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 36),
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
                          const WidgetSpan(
                            child: SizedBox(width: 5),
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
                          const WidgetSpan(
                            child: SizedBox(width: 5),
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
                          const WidgetSpan(
                            child: SizedBox(width: 5),
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
                          const WidgetSpan(
                            child: SizedBox(width: 5),
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
                  // WidgetSpan(
                  //   child: Container(
                  //     padding: const EdgeInsets.only(left: 20),
                  //     child: Text(
                  //       context.tr('terms_of_agreement_content',
                  //           gender: 'right_to_refusal_content'),
                  //       style: CustomTexts.bodyLarge
                  //           .copyWith(color: context.appColors.onBackground),
                  //     ),
                  //   ),
                  // ),
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
                Checkbox(
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  _StatefulBottomSheetState();
}
