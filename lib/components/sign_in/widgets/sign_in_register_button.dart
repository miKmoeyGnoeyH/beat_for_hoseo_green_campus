import 'package:beat_flutter/controller/register/register_organization_controller.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/navigator/arguments/register_arguments.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../managers/navigator/navigator_key_manager.dart';
import '../../../managers/navigator/routes.dart';
import '../../global/widgets/buttons/custom_wide_button.dart';

class SignInRegisterButton extends StatelessWidget {
  SignInRegisterButton({
    super.key,
  });

  final RegisterOrganizationController registerOrganizationController =
      RegisterOrganizationController();

  @override
  Widget build(BuildContext context) {
    return CustomWideButton(
      onTap: () {
        FocusScope.of(context).unfocus();
        onTapTmp;
      },
      buttonColor: context.appColors.background,
      buttonText: context.tr('register'),
      textColor: context.appColors.onBackground,
      borderWidth: 0.5,
    );
  }

  void onTap() {
    NavigatorKeyManager().pushNamed(RouteNames.registerOrganization);
  }

  void onTapTmp() {
    NavigatorKeyManager().pushNamed(
      RouteNames.registerCollege,
      arguments: RegisterArguments(
        registerOrganizationController: registerOrganizationController,
      ),
    );
  }
}
