import 'dart:developer';

import 'package:BEAT/data/provider/register/register_department_provider.dart';
import 'package:easy_localization/easy_localization.dart';

class RegisterCollegeProvider {
  RegisterCollegeProvider(this.registerDepartmentProvider) {
    log('RegisterCollegeProvider');
    colleges = [];
    college = '';
  }

  RegisterCollegeProvider.initColleges(this.registerDepartmentProvider) {
    log('RegisterCollegeProvider');
    colleges = 'colleges'.tr().split(',');
    college = colleges.first;
  }

  RegisterCollegeProvider.initOrgDetails(this.registerDepartmentProvider) {
    log('RegisterCollegeProvider');
    colleges = 'organization_details'.tr().split(',');
    college = colleges.first;
  }

  RegisterCollegeProvider.initAffiliation(this.registerDepartmentProvider) {
    log('RegisterCollegeProvider');
    colleges = [];
    college = '';
  }

  RegisterDepartmentProvider registerDepartmentProvider;
  late final List<String> colleges;
  String college = '';
}