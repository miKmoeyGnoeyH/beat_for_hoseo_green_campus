import 'package:BEAT/data/provider/register/register_agreement_provider.dart';
import 'package:BEAT/data/provider/register/register_department_provider.dart';
import 'package:BEAT/data/provider/register/register_organization_provider.dart';
import 'package:BEAT/data/provider/register/register_sign_provider.dart';
import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/provider/register/register_college_provider.dart';
import '../../managers/navigator/navigator_key_manager.dart';
import '../../managers/navigator/routes.dart';
import '../../theme/texts/custom_texts.dart';
import '../global/custom_appbar.dart';
import '../global/custom_scaffold.dart';

class RegisterOrgDetailScreen extends StatefulWidget {
  const RegisterOrgDetailScreen({super.key});

  @override
  State<RegisterOrgDetailScreen> createState() =>
      _RegisterOrgDetailScreenState();
}

class _RegisterOrgDetailScreenState extends State<RegisterOrgDetailScreen> {
  final RegisterOrganizationProvider _registerController =
      RegisterOrganizationProvider()
        ..registerCollegeProvider = RegisterCollegeProvider.initOrgDetails(
            RegisterDepartmentProvider(
                RegisterSignProvider(RegisterAgreementProvider())));

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
            childCount: organizationDetails.length,
            onSelectedItemChanged: (index) => setState(() {
              organizationDetail = organizationDetails[index];
            }),
            itemBuilder: (context, index) => Center(
              child: Text(
                organizationDetails[index],
                style: CustomTexts.displayMedium
                    .copyWith(color: context.appColors.onBackground),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          NavigatorKeyManager().pushNamed(RouteNames.registerFillInform);
        },
        child: BottomAppBar(
          height: context.width * 0.12,
          color: context.appColors.primary,
          child: Center(
            child: AutoSizeText(
              maxLines: 1,
              context.tr('continue_with', args: [organizationDetail]),
              style: CustomTexts.titleLarge.copyWith(
                color: context.appColors.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<String> get organizationDetails =>
      _registerController.registerCollegeProvider.colleges;

  String get organizationDetail =>
      _registerController.registerCollegeProvider.college;

  set organizationDetail(String organizationDetail) =>
      _registerController.registerCollegeProvider.college = organizationDetail;
}
