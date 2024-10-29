import 'package:BEAT/controller/register/register_basic_events.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/register/register_department_controller.dart';
import '../../managers/navigator/navigator_key_manager.dart';
import '../../managers/navigator/routes.dart';
import '../global/widgets/buttons/custom_bottom_appbar_button.dart';
import '../global/widgets/custom_scaffold.dart';
import '../global/widgets/custom_text_field.dart';
import '../register_organization/widgets/register_organization_appbar.dart';

class RegisterAffiliationScreen extends StatefulWidget {
  const RegisterAffiliationScreen({super.key});

  @override
  State<RegisterAffiliationScreen> createState() =>
      _RegisterAffiliationScreenState();
}

class _RegisterAffiliationScreenState extends State<RegisterAffiliationScreen> {
  @override
  Widget build(BuildContext context) {
    final RegisterDepartmentController registerDepartmentController =
        context.read<RegisterDepartmentController>();

    return CustomScaffold(
      top: false,
      isScrollable: false,
      appBar: RegisterBasicAppbar(
        text: context.tr('affiliation'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: CustomTextField(
            maxLength: 10,
            onChanged: (value) => registerDepartmentController.add(
              RegisterBasicInformChangedByValue(value),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomAppbarButton(
        onTap: () =>
            NavigatorKeyManager().pushNamed(RouteNames.registerFillInform),
        text: context.tr('continue_with',
            args: [registerDepartmentController.state.value]),
      ),
    );
  }
}
