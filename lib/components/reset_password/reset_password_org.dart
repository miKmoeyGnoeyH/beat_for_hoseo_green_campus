import 'package:beat_flutter/components/register_organization/widgets/register_organization_appbar.dart';
import 'package:beat_flutter/controller/reset_password/reset_password_controller.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/navigator/arguments/reset_password_arguments.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../managers/navigator/navigator_key_manager.dart';
import '../../managers/navigator/routes.dart';
import '../global/widgets/buttons/custom_bottom_appbar_button.dart';
import '../global/widgets/custom_cupertino_picker.dart';
import '../global/widgets/custom_scaffold.dart';

class ResetPasswordOrg extends StatefulWidget {
  ResetPasswordOrg({super.key});

  final ResetPasswordController resetPasswordController =
  ResetPasswordController();

  @override
  State<ResetPasswordOrg> createState() =>
      _ResetPasswordOrgState();
}

class _ResetPasswordOrgState
    extends State<ResetPasswordOrg> {
  final LocalizationManager localizationManager = LocalizationManager();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      top: false,
      isScrollable: false,
      appBar: RegisterBasicAppbar(
        text: localizationManager.roAppbarTitle,
      ),
      body: CustomCupertinoPicker(
        items: resetPasswordController.organizations,
        onSelectedItemChanged: (index) => setState(
              () {
            resetPasswordController.organization =
            resetPasswordController.organizations[index];
          },
        ),
      ),
      bottomNavigationBar: CustomBottomAppbarButton(
        onTap: ()
        {
          FocusScope.of(context).unfocus();
          NavigatorKeyManager().pushNamed(
            RouteNames.resetPassword,
            arguments: ResetPasswordArguments(
              resetPasswordController: resetPasswordController,
            ),
          );
        },
        text: localizationManager
            .roContinueWith(resetPasswordController.organization),
      ),
    );
  }

  ResetPasswordController get resetPasswordController =>
      widget.resetPasswordController;
}
