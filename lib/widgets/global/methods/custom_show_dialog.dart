import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../managers/navigator/navigator_key_manager.dart';
import '../../../theme/texts/custom_texts.dart';
import '../custom_rounded_bordered_container.dart';

Future<dynamic> customShowDialog(
    BuildContext context, String title, String content) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: context.appColors.background,
      titlePadding: const EdgeInsets.only(left: 20, right: 20, top: 16),
      title: Text(
        title,
        style: CustomTexts.titleLarge
            .copyWith(color: context.appColors.onBackground),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      content: Text(
        content,
        style: CustomTexts.bodyLarge
            .copyWith(color: context.appColors.onBackground),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.symmetric(horizontal:20, vertical: 16),
      actions: [
        GestureDetector(
          onTap: () => NavigatorKeyManager().pop(),
          child: CustomRoundedBorderedContainer(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  context.tr('confirm'),
                  style: CustomTexts.subtitleLarge
                      .copyWith(color: context.appColors.onPrimary),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}