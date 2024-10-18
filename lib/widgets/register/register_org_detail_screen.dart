import 'dart:ui';

import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme/texts/custom_texts.dart';
import '../global/custom_appbar.dart';
import '../global/custom_scaffold.dart';

class RegisterOrgDetailScreen extends StatefulWidget {
  const RegisterOrgDetailScreen({super.key});

  @override
  State<RegisterOrgDetailScreen> createState() =>
      _RegisterOrgDetailScreenState();
}

// TODO: DepartmentBloc의 상태를 갱신
class _RegisterOrgDetailScreenState extends State<RegisterOrgDetailScreen> {
  String _organizationDetail = 'other_universities'.tr();
  final List<String> _organizationDetails = [
    'other_universities'.tr(),
    'korean_language_center'.tr(),
    'local_residents'.tr(),
    'below_high_school'.tr(),
    'enterprises'.tr(),
    'another'.tr(),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      top: false,
      isScrollable: false,
      appBar: CustomAppBar(
        title: Text(
          context.tr('organization_detail'),
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
            childCount: _organizationDetails.length,
            onSelectedItemChanged: (index) => setState(() {
              _organizationDetail = _organizationDetails[index];
            }),
            itemBuilder: (context, index) => Center(
              child: Text(
                _organizationDetails[index],
                style: CustomTexts.displayMedium
                    .copyWith(color: context.appColors.onBackground),
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
              context.tr('continue_with', args: [_organizationDetail]),
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
