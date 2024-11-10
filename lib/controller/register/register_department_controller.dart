import 'package:easy_localization/easy_localization.dart';

class RegisterDepartmentController {
  RegisterDepartmentController.fromCollege(String college) {
    departments = 'departments'.tr(gender: college).split(',');
    department = 'departments'.tr(gender: college).split(',').first;
  }

  RegisterDepartmentController.fromAffiliation();

  RegisterDepartmentController.fromOrgDetail() {
    departments = 'organization_details'.tr().split(',');
    department = 'organization_details'.tr().split(',').first;
  }

  late final List<String> departments;
  String department = '';
}
