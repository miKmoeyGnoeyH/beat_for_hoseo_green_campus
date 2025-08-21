import 'dart:developer';

import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../../theme/texts/custom_texts.dart';

class CustomBottomAppbar extends StatelessWidget {
  const CustomBottomAppbar({
    super.key,
    this.backgroundColor,
    this.text,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    // log('custom_bottom_appbar.dart : build() : backgroundColor : $backgroundColor');
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: context.appColors.borderColor,
            width: 0.1,
          ),
        ),
      ),
      child: BottomAppBar(
        height: context.width * 0.12,
        color: backgroundColor ?? context.appColors.primary,
        child: Center(
          child: AutoSizeText(
            maxLines: 1,
            text ?? '',
            style: CustomTexts.titleLarge.copyWith(
              color: context.appColors.onPrimary,
            ),
          ),
        ),
      ),
    );
  }

  final Color? backgroundColor;
  final String? text;
  final Color? textColor;
}