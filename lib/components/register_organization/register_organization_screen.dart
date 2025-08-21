import 'package:beat_flutter/managers/navigator/arguments/register_arguments.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../controller/register/register_organization_controller.dart';
import '../../managers/navigator/navigator_key_manager.dart';
import '../../managers/navigator/routes.dart';
import '../global/widgets/buttons/custom_bottom_appbar_button.dart';
import '../global/widgets/custom_cupertino_picker.dart';
import '../global/widgets/custom_scaffold.dart';
import 'widgets/register_organization_appbar.dart';

class RegisterOrganizationScreen extends StatefulWidget {
  RegisterOrganizationScreen({super.key});

  final RegisterOrganizationController registerOrganizationController =
      RegisterOrganizationController();

  @override
  State<RegisterOrganizationScreen> createState() =>
      _RegisterOrganizationScreenState();
}

class _RegisterOrganizationScreenState
    extends State<RegisterOrganizationScreen> {
  void doSomethingDependsOnOrganization(String organization) {
    if (organization == 'student'.tr()) {
      NavigatorKeyManager().pushNamed(
        RouteNames.registerCollege,
        arguments: RegisterArguments(
          registerOrganizationController: registerOrganizationController,
        ),
      );
    } else if (organization == 'faculty_and_staff'.tr()) {
      NavigatorKeyManager().pushNamed(
        RouteNames.registerAffiliation,
        arguments: RegisterArguments(
          registerOrganizationController: registerOrganizationController,
        ),
      );
    } else if (organization == 'postgraduate_student'.tr()) {
      NavigatorKeyManager().pushNamed(
        RouteNames.registerFillInform,
        arguments: RegisterArguments(
          registerOrganizationController: registerOrganizationController,
        ),
      );
    } else {
      NavigatorKeyManager().pushNamed(
        RouteNames.registerOrgDetail,
        arguments: RegisterArguments(
          registerOrganizationController: registerOrganizationController,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      top: false,
      isScrollable: false,
      appBar: RegisterBasicAppbar(
        text: context.tr('organization'),
      ),
      body: CustomCupertinoPicker(
        items: registerOrganizationController.organizations,
        onSelectedItemChanged: (index) => setState(
          () {
            registerOrganizationController.organization =
                registerOrganizationController.organizations[index];
          },
        ),
      ),
      bottomNavigationBar: CustomBottomAppbarButton(
        onTap: () => doSomethingDependsOnOrganization(
          registerOrganizationController.organization,
        ),
        text: context.tr(
          'continue_with',
          args: [registerOrganizationController.organization],
        ),
      ),
    );
  }

  RegisterOrganizationController get registerOrganizationController =>
      widget.registerOrganizationController;
}
