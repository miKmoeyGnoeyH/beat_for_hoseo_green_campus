import 'package:BEAT/data/provider/register/register_organization_provider.dart';
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

class RegisterDepartmentScreen extends StatefulWidget {
  const RegisterDepartmentScreen({super.key});

  @override
  State<RegisterDepartmentScreen> createState() =>
      _RegisterDepartmentScreenState();
}

class _RegisterDepartmentScreenState extends State<RegisterDepartmentScreen> {
  final String college = RegisterOrganizationProvider().registerCollegeProvider.college;
  final RegisterOrganizationProvider _registerController = RegisterOrganizationProvider()..setRegisterDepartmentProviderFromCollege();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      top: false,
      isScrollable: false,
      appBar: CustomAppBar(
        title: Text(
          context.tr('department'),
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
            childCount: departments.length,
            onSelectedItemChanged: (index) => setState(() {
              department = departments[index];
            }),
            itemBuilder: (context, index) => Center(
              child: AutoSizeText(
                maxLines: 1,
                departments[index],
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
              context.tr('continue_with', args: [department]),
              style: CustomTexts.titleLarge.copyWith(
                color: context.appColors.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<String> get departments => _registerController.registerDepartmentProvider.departments;
  String get department => _registerController.registerDepartmentProvider.department;
  set department(String department) => _registerController.registerDepartmentProvider.department = department;
}
