import 'package:BEAT/controller/register/register_department_controller.dart';
import 'package:BEAT/controller/register/register_sign_controller.dart';
import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../controller/register/register_agreement_controller.dart';
import '../../controller/register/register_college_controller.dart';
import '../../controller/register/register_organization_controller.dart';
import '../../managers/navigator/navigator_key_manager.dart';
import '../../managers/navigator/routes.dart';
import '../../theme/texts/custom_texts.dart';
import '../global/custom_appbar.dart';
import '../global/custom_scaffold.dart';

class RegisterOrganizationScreen extends StatefulWidget {
  const RegisterOrganizationScreen({super.key});

  @override
  State<RegisterOrganizationScreen> createState() =>
      _RegisterOrganizationScreenState();
}

class _RegisterOrganizationScreenState extends State<RegisterOrganizationScreen> {
  final RegisterOrganizationController _registerController = RegisterOrganizationController.init();

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
            childCount: organizations.length,
            onSelectedItemChanged: (index) => setState(() {
              organization = organizations[index];
            }),
            itemBuilder: (context, index) => Center(
              child: Text(
                organizations[index],
                style: CustomTexts.displayMedium
                    .copyWith(color: context.appColors.onBackground),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          if (organization == 'student'.tr()) {
            NavigatorKeyManager()
                .pushNamed(RouteNames.registerCollege);
          } else if (organization == 'faculty_and_staff'.tr()) {
            NavigatorKeyManager()
                .pushNamed(RouteNames.registerAffiliation);
          } else if (organization == 'postgraduate_student'.tr()) {
            _registerController.registerCollegeProvider = RegisterCollegeController(RegisterDepartmentController(RegisterSignController(RegisterAgreementController())));
            NavigatorKeyManager().pushNamed(RouteNames.registerFillInform);
          } else {
            NavigatorKeyManager()
                .pushNamed(RouteNames.registerOrgDetail);
          }
        },
        child: BottomAppBar(
          height: context.width * 0.12,
          color: context.appColors.primary,
          child: Center(
            child: AutoSizeText(
              maxLines: 1,
              context.tr('continue_with', args: [organization]),
              style: CustomTexts.titleLarge.copyWith(
                color: context.appColors.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<String> get organizations => _registerController.organizations;
  String get organization => _registerController.organization;
  set organization(String organization) => _registerController.organization = organization;
}
