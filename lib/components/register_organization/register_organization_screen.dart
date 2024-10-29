import 'package:BEAT/controller/register/register_basic_events.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/register/register_organization_controller.dart';
import '../../managers/navigator/navigator_key_manager.dart';
import '../../managers/navigator/routes.dart';
import '../global/widgets/buttons/custom_bottom_appbar_button.dart';
import '../global/widgets/custom_cupertino_picker.dart';
import '../global/widgets/custom_scaffold.dart';
import 'widgets/register_organization_appbar.dart';

class RegisterOrganizationScreen extends StatefulWidget {
  const RegisterOrganizationScreen({super.key});

  @override
  State<RegisterOrganizationScreen> createState() =>
      _RegisterOrganizationScreenState();
}

class _RegisterOrganizationScreenState
    extends State<RegisterOrganizationScreen> {
  void doSomethingDependsOnOrganization(String organization) {
    if (organization == 'student'.tr()) {
      NavigatorKeyManager().pushNamed(RouteNames.registerCollege);
    } else if (organization == 'faculty_and_staff'.tr()) {
      NavigatorKeyManager().pushNamed(RouteNames.registerAffiliation);
    } else if (organization == 'postgraduate_student'.tr()) {
      NavigatorKeyManager().pushNamed(RouteNames.registerFillInform);
    } else {
      NavigatorKeyManager().pushNamed(RouteNames.registerOrgDetail);
    }
  }

  @override
  Widget build(BuildContext context) {
    final RegisterOrganizationController registerOrganizationController =
        context.read<RegisterOrganizationController>();

    return CustomScaffold(
      top: false,
      isScrollable: false,
      appBar: RegisterBasicAppbar(
        text: context.tr('organization'),
      ),
      body: CustomCupertinoPicker(
          items: registerOrganizationController.organizations,
          onSelectedItemChanged: (index) => setState(() {
                registerOrganizationController.add(
                  RegisterBasicInformChangedByIndex(index),
                );
              })),
      bottomNavigationBar: CustomBottomAppbarButton(
        onTap: () => doSomethingDependsOnOrganization(
            registerOrganizationController.state.value),
        text: context.tr('continue_with',
            args: [registerOrganizationController.state.value]),
      ),
    );
  }
}
