import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../theme/texts/custom_texts.dart';
import '../global/custom_appbar.dart';
import '../global/custom_scaffold.dart';

class RegisterAffiliationScreen extends StatelessWidget {
  const RegisterAffiliationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      top: false,
      isScrollable: false,
      appBar: CustomAppBar(
        title: Text(
          context.tr('affiliation'),
          style: CustomTexts.titleLarge,
        ),
        iconTheme: IconThemeData(
          color: context.appColors.primary,
        ),
      ),
      bottomNavigationBar: GestureDetector(
        child: BottomAppBar(
          // height: context.width * 0.1,
          color: context.appColors.primary,
          child: Center(
            child: Text(
              context.tr('next'),
              style: CustomTexts.headlineMedium.copyWith(
                color: context.appColors.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
