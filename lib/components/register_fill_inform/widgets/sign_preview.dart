import 'dart:convert';

import 'package:beat_flutter/components/global/widgets/texts/custom_body_large.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../controller/register_fill_inform/register_sign_controller.dart';
import '../../global/widgets/custom_rounded_bordered_container.dart';

class SignPreview extends StatefulWidget {
  const SignPreview({
    super.key,
    required this.registerSignController,
  });

  final RegisterSignController registerSignController;

  @override
  State<SignPreview> createState() => _SignPreviewState();
}

class _SignPreviewState extends State<SignPreview> {
  final LocalizationManager localizationManager = LocalizationManager();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: CustomRoundedBorderedContainer(
        // width: context.width,
        // height: 200.w,
        borderWidth: 0.5,
        color: context.appColors.background,
        child: registerSignController.handSignatureControl.isFilled
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
                child: Image.memory(
                  base64Decode(registerSignController.signatureBase64),
                  fit: BoxFit.cover,
                ),
              )
            : Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: CustomBodyLarge(
                    text: localizationManager.spSignContent,
                  ),
                  // child: AutoSizeText(
                  //   localizationManager.spSignContent,
                  //   maxLines: 1,
                  //   style: CustomLargeTexts.bodyLarge.copyWith(
                  //     color: context.appColors.onBackground,
                  //   ),
                  // ),
                ),
              ),
      ),
    );
  }

  RegisterSignController get registerSignController =>
      widget.registerSignController;
}
