import 'package:BEAT/controller/register/register_sign_controller.dart';
import 'package:easy_localization/easy_localization.dart';

class RegisterDepartmentController {
  RegisterDepartmentController(this.registerSignProvider);
  RegisterDepartmentController.fromCollege(this.registerSignProvider, String college) {
    departments = 'departments'.tr(gender: college).split(', ');
    department = departments.first;
  }

  RegisterSignController registerSignProvider;
  List<String> departments = [];
  String department = '';
}