import 'package:Beat/controller/register/register_college_controller.dart';
import 'package:Beat/controller/register/register_organization_controller.dart';
import 'package:Beat/managers/navigator/arguments/register_arguments.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../managers/navigator/navigator_key_manager.dart';
import '../../managers/navigator/routes.dart';
import '../global/widgets/buttons/custom_bottom_appbar_button.dart';
import '../global/widgets/custom_cupertino_picker.dart';
import '../global/widgets/custom_scaffold.dart';
import '../register_organization/widgets/register_organization_appbar.dart';

class RegisterCollegeScreen extends StatefulWidget {
  RegisterCollegeScreen(
    this.registerArguments, {
    super.key,
  });

  final RegisterArguments registerArguments;

  final RegisterCollegeController registerCollegeController =
      RegisterCollegeController();

  @override
  State<RegisterCollegeScreen> createState() => _RegisterCollegeScreenState();
}

class _RegisterCollegeScreenState extends State<RegisterCollegeScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      top: false,
      isScrollable: false,
      appBar: RegisterBasicAppbar(
        text: context.tr('college'),
      ),
      body: CustomCupertinoPicker(
        items: registerCollegeController.colleges,
        onSelectedItemChanged: (index) => setState(
          () {
            registerCollegeController.college =
                registerCollegeController.colleges[index];
          },
        ),
      ),
      bottomNavigationBar: CustomBottomAppbarButton(
        onTap: () => NavigatorKeyManager().pushNamed(
          RouteNames.registerDepartment,
          arguments: RegisterArguments(
            registerOrganizationController: registerOrganizationController,
            registerCollegeController: registerCollegeController,
          ),
        ),
        text: context
            .tr('continue_with', args: [registerCollegeController.college]),
      ),
    );
  }

  RegisterOrganizationController? get registerOrganizationController =>
      widget.registerArguments.registerOrganizationController;

  RegisterCollegeController get registerCollegeController =>
      widget.registerCollegeController;
}
