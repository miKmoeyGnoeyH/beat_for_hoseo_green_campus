import 'dart:developer';

import 'package:BEAT/controller/register/register_department_controller.dart';
import 'package:easy_localization/easy_localization.dart';

class RegisterCollegeController {
  RegisterCollegeController(this.registerDepartmentProvider) {
    log('RegisterCollegeProvider');
    colleges = [];
    college = '';
  }

  RegisterCollegeController.initColleges(this.registerDepartmentProvider) {
    log('RegisterCollegeProvider');
    colleges = 'colleges'.tr().split(',');
    college = colleges.first;
  }

  RegisterCollegeController.initOrgDetails(this.registerDepartmentProvider) {
    log('RegisterCollegeProvider');
    colleges = 'organization_details'.tr().split(',');
    college = colleges.first;
  }

  RegisterCollegeController.initAffiliation(this.registerDepartmentProvider) {
    log('RegisterCollegeProvider');
    colleges = [];
    college = '';
  }

  RegisterDepartmentController registerDepartmentProvider;
  late final List<String> colleges;
  String college = '';
}