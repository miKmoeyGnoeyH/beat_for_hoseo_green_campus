import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:BEAT/managers/navigator/navigator_key_manager.dart';
import 'package:BEAT/managers/navigator/routes.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme/texts/custom_texts.dart';
import '../global/custom_appbar.dart';
import '../global/custom_scaffold.dart';

class RegisterOrganizationScreen extends StatefulWidget {
  const RegisterOrganizationScreen({super.key});

  @override
  State<RegisterOrganizationScreen> createState() =>
      _RegisterOrganizationScreenState();
}

// TODO: OrgBloc의 상태를 갱신
class _RegisterOrganizationScreenState extends State<RegisterOrganizationScreen> {
  String _organization = 'student'.tr();
  final List<String> _organizations = [
    'student'.tr(),
    'faculty_and_staff'.tr(),
    'postgraduate_student'.tr(),
    'other'.tr(),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      top: false,
      isScrollable: false,
      appBar: CustomAppBar(
        title: Text(
          context.tr('organization'),
          style: CustomTexts.displaySmall,
        ),
        iconTheme: IconThemeData(
          color: context.appColors.primary,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: CupertinoPicker.builder(
            itemExtent: 50,
            childCount: _organizations.length,
            onSelectedItemChanged: (index) => setState(() {
              _organization = _organizations[index];
            }),
            itemBuilder: (context, index) => Center(
              child: Text(
                _organizations[index],
                style: CustomTexts.displayMedium
                    .copyWith(color: context.appColors.onBackground),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          Map<String, String> args = {'organization': _organization};
          if (_organization == 'student'.tr()) {
            NavigatorKeyManager()
                .pushNamed(RouteNames.registerCollege, arguments: args);
          } else if (_organization == 'faculty_and_staff'.tr()) {
            NavigatorKeyManager()
                .pushNamed(RouteNames.registerAffiliation, arguments: args);
          } else if (_organization == 'postgraduate_student'.tr()) {
            return;
          } else {
            NavigatorKeyManager()
                .pushNamed(RouteNames.registerOrgDetail, arguments: args);
          }
        },
        child: BottomAppBar(
          height: context.width * 0.13,
          color: context.appColors.primary,
          child: Center(
            child: AutoSizeText(
              maxLines: 1,
              context.tr('continue_with', args: [_organization]),
              style: CustomTexts.titleLarge.copyWith(
                color: context.appColors.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
