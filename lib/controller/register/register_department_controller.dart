import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:easy_localization/easy_localization.dart';

class RegisterDepartmentController {
  RegisterDepartmentController.fromCollege(String college) {
    localizationManager = LocalizationManager();
    departments = localizationManager.departmentsFromCollage(college);
    department = departments.first;
  }

  RegisterDepartmentController.fromAffiliation();

  RegisterDepartmentController.fromOrgDetail() {
    departments = 'organization_details'.tr().split(',');
    department = 'organization_details'.tr().split(',').first;
  }

  late final LocalizationManager localizationManager;
  late final List<String> departments;
  String department = '';
}
