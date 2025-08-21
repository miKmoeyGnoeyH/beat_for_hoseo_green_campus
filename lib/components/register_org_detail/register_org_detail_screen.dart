import 'package:beat_flutter/controller/register/register_department_controller.dart';
import 'package:beat_flutter/managers/navigator/arguments/register_arguments.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../controller/register/register_college_controller.dart';
import '../../controller/register/register_organization_controller.dart';
import '../../managers/navigator/navigator_key_manager.dart';
import '../../managers/navigator/routes.dart';
import '../global/widgets/buttons/custom_bottom_appbar_button.dart';
import '../global/widgets/custom_cupertino_picker.dart';
import '../global/widgets/custom_scaffold.dart';
import '../register_organization/widgets/register_organization_appbar.dart';

class RegisterOrgDetailScreen extends StatefulWidget {
  RegisterOrgDetailScreen(
    this.registerArguments, {
    super.key,
  });

  final RegisterArguments registerArguments;
  final RegisterDepartmentController registerDepartmentController =
      RegisterDepartmentController.fromOrgDetail();

  @override
  State<RegisterOrgDetailScreen> createState() =>
      _RegisterOrgDetailScreenState();
}

class _RegisterOrgDetailScreenState extends State<RegisterOrgDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      top: false,
      isScrollable: false,
      appBar: RegisterBasicAppbar(
        text: context.tr('organization_detail'),
      ),
      body: CustomCupertinoPicker(
        items: registerDepartmentController.departments,
        onSelectedItemChanged: (index) => setState(
          () {
            registerDepartmentController.department =
                registerDepartmentController.departments[index];
          },
        ),
      ),
      bottomNavigationBar: CustomBottomAppbarButton(
        onTap: () => NavigatorKeyManager().pushNamed(
          RouteNames.registerFillInform,
          arguments: RegisterArguments(
            registerOrganizationController: registerOrganizationController,
            registerCollegeController: registerCollegeController,
            registerDepartmentController: registerDepartmentController,
          ),
        ),
        text: context.tr('continue_with',
            args: [registerDepartmentController.department]),
      ),
    );
  }

  RegisterOrganizationController? get registerOrganizationController =>
      widget.registerArguments.registerOrganizationController;

  RegisterCollegeController? get registerCollegeController =>
      widget.registerArguments.registerCollegeController;

  RegisterDepartmentController get registerDepartmentController =>
      widget.registerDepartmentController;
}
