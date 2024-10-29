
import 'package:BEAT/controller/register/register_basic_events.dart';
import 'package:BEAT/controller/register/register_college_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../managers/navigator/navigator_key_manager.dart';
import '../../managers/navigator/routes.dart';
import '../global/widgets/buttons/custom_bottom_appbar_button.dart';
import '../global/widgets/custom_cupertino_picker.dart';
import '../global/widgets/custom_scaffold.dart';
import '../register_organization/widgets/register_organization_appbar.dart';

class RegisterCollegeScreen extends StatefulWidget {
  const RegisterCollegeScreen({super.key});

  @override
  State<RegisterCollegeScreen> createState() => _RegisterCollegeScreenState();
}

class _RegisterCollegeScreenState extends State<RegisterCollegeScreen> {
  @override
  Widget build(BuildContext context) {
    final RegisterCollegeController registerCollegeController =
        context.read<RegisterCollegeController>();

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
            registerCollegeController.add(
              RegisterBasicInformChangedByIndex(index),
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomAppbarButton(
        onTap: () => NavigatorKeyManager()
            .pushNamed(RouteNames.registerDepartment),
        text: context
            .tr('continue_with', args: [registerCollegeController.state.value]),
      ),
    );
  }
}
