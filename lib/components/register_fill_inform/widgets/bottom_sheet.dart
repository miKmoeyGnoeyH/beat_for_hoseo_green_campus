// import 'package:BEAT/extensions/buildcontext_extension.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
//
// import '../../../controller/register_fill_inform/register_agreement_controller.dart';
// import '../../../controller/register/register_organization_controller.dart';
// import '../../../theme/texts/custom_texts.dart';
// import '../../global/widgets/custom_rounded_bordered_container.dart';
//
// class StatefulBottomSheet extends StatefulWidget {
//   const StatefulBottomSheet({super.key, required this.setIsAgreementChecked});
//
//   final Function(bool) setIsAgreementChecked;
//
//   @override
//   State<StatefulBottomSheet> createState() => _StatefulBottomSheetState();
// }
//
// class _StatefulBottomSheetState extends State<StatefulBottomSheet> {
//   final RegisterAgreementController _registerAgreementProvider =
//       RegisterOrganizationController().registerAgreementProvider;
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomRoundedBorderedContainer(
//       color: context.appColors.background,
//       height: context.height * 0.65,
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(
//               horizontal: 20.0, vertical: 36),
//           child: Column(
//             // mainAxisAlignment:
//             //     MainAxisAlignment.spaceBetween,
//             children: [
//               Text.rich(
//                 TextSpan(
//                   children: [
//                     TextSpan(
//                       text: context
//                           .tr('terms_of_agreement_title'),
//                       style: CustomTexts.subtitleLarge
//                           .copyWith(
//                           color: context.appColors
//                               .onBackground),
//                     ),
//                     WidgetSpan(child: Container()),
//                     TextSpan(
//                       children: [
//                         TextSpan(
//                           text: '1.',
//                           style: CustomTexts
//                               .subtitleMedium
//                               .copyWith(
//                               color: context.appColors
//                                   .onBackground),
//                         ),
//                         TextSpan(
//                           children: [
//                             const WidgetSpan(
//                               child: SizedBox(width: 5),
//                             ),
//                             TextSpan(
//                               text: context.tr(
//                                   'terms_of_agreement_content',
//                                   gender: 'purpose'),
//                               style: CustomTexts
//                                   .subtitleMedium
//                                   .copyWith(
//                                   color: context
//                                       .appColors
//                                       .onBackground),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     TextSpan(
//                       children: [
//                         const WidgetSpan(
//                           child: SizedBox(width: 20),
//                         ),
//                         TextSpan(
//                           text: context.tr(
//                               'terms_of_agreement_content',
//                               gender: 'purpose_content'),
//                           style: CustomTexts.bodyLarge
//                               .copyWith(
//                               color: context.appColors
//                                   .onBackground),
//                         ),
//                       ],
//                     ),
//                     WidgetSpan(child: Container()),
//                     TextSpan(
//                       children: [
//                         TextSpan(
//                           text: '2.',
//                           style: CustomTexts
//                               .subtitleMedium
//                               .copyWith(
//                               color: context.appColors
//                                   .onBackground),
//                         ),
//                         TextSpan(
//                           children: [
//                             const WidgetSpan(
//                               child: SizedBox(width: 5),
//                             ),
//                             TextSpan(
//                               text: context.tr(
//                                   'terms_of_agreement_content',
//                                   gender: 'items'),
//                               style: CustomTexts
//                                   .subtitleMedium
//                                   .copyWith(
//                                   color: context
//                                       .appColors
//                                       .onBackground),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     WidgetSpan(
//                       child: Container(
//                         padding: const EdgeInsets.only(
//                             left: 20),
//                         child: Text(
//                           context.tr(
//                               'terms_of_agreement_content',
//                               gender: 'items_content'),
//                           style: CustomTexts.bodyLarge
//                               .copyWith(
//                               color: context.appColors
//                                   .onBackground),
//                         ),
//                       ),
//                     ),
//                     WidgetSpan(child: Container()),
//                     TextSpan(
//                       children: [
//                         TextSpan(
//                           text: '3.',
//                           style: CustomTexts
//                               .subtitleMedium
//                               .copyWith(
//                               color: context.appColors
//                                   .onBackground),
//                         ),
//                         TextSpan(
//                           children: [
//                             const WidgetSpan(
//                               child: SizedBox(width: 5),
//                             ),
//                             TextSpan(
//                               text: context.tr(
//                                   'terms_of_agreement_content',
//                                   gender: 'retention'),
//                               style: CustomTexts
//                                   .subtitleMedium
//                                   .copyWith(
//                                   color: context
//                                       .appColors
//                                       .onBackground),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     WidgetSpan(
//                       child: Container(
//                         padding: const EdgeInsets.only(
//                             left: 20),
//                         child: Text(
//                           context.tr(
//                               'terms_of_agreement_content',
//                               gender:
//                               'retention_content'),
//                           style: CustomTexts.bodyLarge
//                               .copyWith(
//                               color: context.appColors
//                                   .onBackground),
//                         ),
//                       ),
//                     ),
//                     WidgetSpan(child: Container()),
//                     TextSpan(
//                       children: [
//                         TextSpan(
//                           text: '4.',
//                           style: CustomTexts
//                               .subtitleMedium
//                               .copyWith(
//                               color: context.appColors
//                                   .onBackground),
//                         ),
//                         TextSpan(
//                           children: [
//                             const WidgetSpan(
//                               child: SizedBox(width: 5),
//                             ),
//                             TextSpan(
//                               text: context.tr(
//                                   'terms_of_agreement_content',
//                                   gender:
//                                   'right_to_refusal'),
//                               style: CustomTexts
//                                   .subtitleMedium
//                                   .copyWith(
//                                   color: context
//                                       .appColors
//                                       .onBackground),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     WidgetSpan(
//                       child: Container(
//                         padding: const EdgeInsets.only(
//                             left: 20),
//                         child: Text(
//                           context.tr(
//                               'terms_of_agreement_content',
//                               gender:
//                               'right_to_refusal_content'),
//                           style: CustomTexts.bodyLarge
//                               .copyWith(
//                               color: context.appColors
//                                   .onBackground),
//                         ),
//                       ),
//                     ),
//                     WidgetSpan(child: Container()),
//                     TextSpan(
//                       text: context.tr('do_you_agree'),
//                       style: CustomTexts.subtitleLarge
//                           .copyWith(
//                           color: context.appColors
//                               .onBackground),
//                     ),
//                     WidgetSpan(child: Container()),
//                   ],
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment:
//                 MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     context.tr('i_agree'),
//                     style: CustomTexts.subtitleLarge
//                         .copyWith(
//                         color: context
//                             .appColors.onBackground),
//                   ),
//                   Checkbox(
//                     value: _registerAgreementProvider
//                         .isAgreementChecked,
//                     activeColor:
//                     context.appColors.primary,
//                     shape: RoundedRectangleBorder(
//                       borderRadius:
//                       BorderRadius.circular(10),
//                     ),
//                     onChanged: (value) {
//                       setState(() {
//                         widget.setIsAgreementChecked(value!);
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   _StatefulBottomSheetState();
// }
