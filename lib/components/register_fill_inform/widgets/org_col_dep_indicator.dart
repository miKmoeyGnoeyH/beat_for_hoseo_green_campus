import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controller/register/register_college_controller.dart';
import '../../../controller/register/register_department_controller.dart';
import '../../../controller/register/register_organization_controller.dart';
import 'org_col_dep_label.dart';

class OrgColDepIndicator extends StatelessWidget {
  const OrgColDepIndicator({
    super.key,
    this.colText,
    this.orgText,
    this.depText,
  });

  @override
  Widget build(BuildContext context) {
    final RegisterOrganizationController registerOrganizationController =
        context.read<RegisterOrganizationController>();

    final RegisterCollegeController registerCollegeController =
        context.read<RegisterCollegeController>();

    final RegisterDepartmentController registerDepartmentController =
        context.read<RegisterDepartmentController>();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          OrgColDepLabel(text: registerOrganizationController.state.value),
          const SizedBox(width: 15),
          OrgColDepLabel(
              text: registerDepartmentController.state.value != ''
                  ? context.tr('register_college_of',
                      args: [registerCollegeController.state.value])
                  : registerCollegeController.state.value),
          const SizedBox(width: 15),
          OrgColDepLabel(text: registerDepartmentController.state.value),
        ],
      ),
    );
  }

  final String? orgText;
  final String? colText;
  final String? depText;
}