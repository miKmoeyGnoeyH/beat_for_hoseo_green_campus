import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../managers/navigator/navigator_key_manager.dart';
import '../../../theme/texts/custom_texts.dart';
import '../widgets/custom_rounded_bordered_container.dart';

Future<dynamic> customShowDialog(
    {required BuildContext context, required String? title, required String? content, String? routeName}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: context.appColors.borderColor,
          width: 0.1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: context.appColors.background,
      titlePadding: const EdgeInsets.only(left: 20, right: 20, top: 16),
      title: title != null ? Text(
        title,
        style: CustomTexts.titleLarge
            .copyWith(color: context.appColors.onBackground),
      ) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      content: content != null ? Text(
        content,
        style: CustomTexts.bodyLarge
            .copyWith(color: context.appColors.onBackground),
      ) : null,
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.symmetric(horizontal:20, vertical: 16),
      actions: [
        GestureDetector(
          onTap: () => routeName != null ? NavigatorKeyManager().popUntil(routeName) : NavigatorKeyManager().pop(),
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