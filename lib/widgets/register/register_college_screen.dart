import 'package:BEAT/controller/register/register_sign_controller.dart';
import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../controller/register/register_agreement_controller.dart';
import '../../controller/register/register_college_controller.dart';
import '../../controller/register/register_department_controller.dart';
import '../../controller/register/register_organization_controller.dart';
import '../../managers/navigator/navigator_key_manager.dart';
import '../../managers/navigator/routes.dart';
import '../../theme/texts/custom_texts.dart';
import '../global/custom_appbar.dart';
import '../global/custom_scaffold.dart';

class RegisterCollegeScreen extends StatefulWidget {
  const RegisterCollegeScreen({super.key});

  @override
  State<RegisterCollegeScreen> createState() => _RegisterCollegeScreenState();
}

class _RegisterCollegeScreenState extends State<RegisterCollegeScreen> {
  final RegisterOrganizationController _registerController =
      RegisterOrganizationController()
        ..registerCollegeProvider = RegisterCollegeController.initColleges(
            RegisterDepartmentController(
                RegisterSignController(RegisterAgreementController())));

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      top: false,
      isScrollable: false,
      appBar: CustomAppBar(
        title: Text(
          context.tr('college'),
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
            childCount: colleges.length,
            onSelectedItemChanged: (index) => setState(() {
              college = colleges[index];
            }),
            itemBuilder: (context, index) => Center(
              child: Text(
                colleges[index],
                style: CustomTexts.displayMedium
                    .copyWith(color: context.appColors.onBackground),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          NavigatorKeyManager().pushNamed(
            RouteNames.registerDepartment,
          );
        },
        child: BottomAppBar(
          height: context.width * 0.12,
          color: context.appColors.primary,
          child: Center(
            child: AutoSizeText(
              maxLines: 1,
              context.tr('continue_with', args: [college]),
              style: CustomTexts.titleLarge.copyWith(
                color: context.appColors.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<String> get colleges =>
      _registerController.registerCollegeProvider.colleges;

  String get college => _registerController.registerCollegeProvider.college;

  set college(String college) =>
      _registerController.registerCollegeProvider.college = college;
}
