import 'dart:developer';

import 'package:BEAT/controller/register/register_basic_events.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/register/register_department_controller.dart';
import '../../managers/navigator/navigator_key_manager.dart';
import '../../managers/navigator/routes.dart';
import '../global/widgets/buttons/custom_bottom_appbar_button.dart';
import '../global/widgets/custom_cupertino_picker.dart';
import '../global/widgets/custom_scaffold.dart';
import '../register_organization/widgets/register_organization_appbar.dart';

class RegisterDepartmentScreen extends StatefulWidget {
  const RegisterDepartmentScreen({super.key});

  @override
  State<RegisterDepartmentScreen> createState() =>
      _RegisterDepartmentScreenState();
}

class _RegisterDepartmentScreenState extends State<RegisterDepartmentScreen> {
  @override
  Widget build(BuildContext context) {
    final RegisterDepartmentController registerDepartmentController =
        context.read<RegisterDepartmentController>();

    return CustomScaffold(
      top: false,
      isScrollable: false,
      appBar: RegisterBasicAppbar(
        text: context.tr('department'),
      ),
      body: CustomCupertinoPicker(
        items: registerDepartmentController.departments,
        onSelectedItemChanged: (index) => setState(
          () {
            registerDepartmentController.add(
              RegisterBasicInformChangedByIndex(index),
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomAppbarButton(
        onTap: () => NavigatorKeyManager()
            .pushNamed(RouteNames.registerFillInform),
        text: context.tr('continue_with',
            args: [registerDepartmentController.state.value]),
      ),
    );
  }
}
