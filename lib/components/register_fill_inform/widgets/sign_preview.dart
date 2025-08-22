import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../controller/register_fill_inform/register_sign_controller.dart';
import '../../../theme/texts/custom_texts.dart';
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
  @override
  Widget build(BuildContext context) {
    return CustomRoundedBorderedContainer(
      width: context.width,
      height: 200,
      borderWidth: 0.5,
      color: context.appColors.background,
      child: registerSignController.sign.isNotEmpty
          ? Center(
              child: Image.memory(
                registerSignController.sign,
                fit: BoxFit.contain,
                // alignment: Alignment.center,
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: AutoSizeText(
                  context.tr('sign_content'),
                  maxLines: 1,
                  style: CustomTexts.bodyLarge.copyWith(
                    color: context.appColors.onBackground,
                  ),
                ),
              ),
            ),
    );
  }

  RegisterSignController get registerSignController =>
      widget.registerSignController;
}
