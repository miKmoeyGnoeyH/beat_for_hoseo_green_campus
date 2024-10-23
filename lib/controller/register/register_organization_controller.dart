import 'dart:developer';

import 'package:BEAT/controller/register/register_sign_controller.dart';
import 'package:easy_localization/easy_localization.dart';

import 'register_agreement_controller.dart';
import 'register_college_controller.dart';
import 'register_department_controller.dart';

class RegisterOrganizationController{
  static RegisterOrganizationController? _instance;

  RegisterOrganizationController._internal() {
    organizations = [
      'student'.tr(),
      'faculty_and_staff'.tr(),
      'postgraduate_student'.tr(),
      'other'.tr()
    ];
    organization = organizations.first;
  }

  factory RegisterOrganizationController() =>
      _instance ??= RegisterOrganizationController._internal();

  factory RegisterOrganizationController.init() {
    log('RegisterOrganizationProvider.init');
    return _instance = RegisterOrganizationController._internal();
  }

  RegisterCollegeController registerCollegeProvider =
      RegisterCollegeController(RegisterDepartmentController(RegisterSignController(RegisterAgreementController())));
  late final List<String> organizations;
  String organization = '';

  RegisterDepartmentController get registerDepartmentProvider =>
      registerCollegeProvider.registerDepartmentProvider;

  RegisterSignController get registerSignProvider => registerDepartmentProvider.registerSignProvider;

  RegisterAgreementController get registerAgreementProvider => registerSignProvider.registerAgreementProvider;

  set registerDepartmentProvider(
          RegisterDepartmentController registerDepartmentProvider) =>
      registerCollegeProvider.registerDepartmentProvider =
          registerDepartmentProvider;

  void setRegisterDepartmentProviderFromCollege() => registerCollegeProvider
          .registerDepartmentProvider =
      RegisterDepartmentController.fromCollege(RegisterSignController(RegisterAgreementController()), registerCollegeProvider.college);
}
