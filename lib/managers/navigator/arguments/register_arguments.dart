import 'package:BEAT/controller/register/register_department_controller.dart';
import 'package:BEAT/controller/register/register_organization_controller.dart';

import '../../../controller/register/register_college_controller.dart';

class RegisterArguments {
  RegisterArguments({
    this.registerOrganizationController,
    this.registerCollegeController,
    this.registerDepartmentController,
  });

  final RegisterOrganizationController? registerOrganizationController;
  final RegisterCollegeController? registerCollegeController;
  final RegisterDepartmentController? registerDepartmentController;
}