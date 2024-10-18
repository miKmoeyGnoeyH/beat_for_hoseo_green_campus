import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../theme/texts/custom_texts.dart';
import '../global/custom_appbar.dart';
import '../global/custom_scaffold.dart';

class RegisterAffiliationScreen extends StatefulWidget {

  const RegisterAffiliationScreen({super.key});

  @override
  State<RegisterAffiliationScreen> createState() => _RegisterAffiliationScreenState();
}

// TODO: DepartmentBloc의 상태를 갱신
class _RegisterAffiliationScreenState extends State<RegisterAffiliationScreen> {
  final TextEditingController _affiliationController = TextEditingController();
  final int minLength = 3;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      onTapDown: (_) => FocusScope.of(context).unfocus(),
      child: CustomScaffold(
        top: false,
        isScrollable: false,
        appBar: CustomAppBar(
          title: Text(
            context.tr('affiliation'),
            style: CustomTexts.displaySmall,
          ),
          iconTheme: IconThemeData(
            color: context.appColors.primary,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: TextField(
              controller: _affiliationController,
              maxLength: 10,
              cursorColor: context.appColors.primary,
              onChanged: (_) => setState(() {}),
              style: CustomTexts.bodyLarge.copyWith(
                color: context.appColors.onBackground,
              ),
              decoration: InputDecoration(
                hintText: context.tr("affiliation_hint"),
                hintStyle: CustomTexts.bodyLarge.copyWith(
                  color: context.appColors.onBackground.withOpacity(0.5),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: context.appColors.onBackground.withOpacity(0.2),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: context.appColors.primary,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () {},
          child: BottomAppBar(
            height: context.width * 0.13,
            color: context.appColors.primary,
            child: Center(
              child: AutoSizeText(
                maxLines: 1,
                context.tr('continue_with', args: [_affiliationController.text]),
                style: CustomTexts.titleLarge.copyWith(
                  color: context.appColors.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String get affiliation => _affiliationController.text;
}
