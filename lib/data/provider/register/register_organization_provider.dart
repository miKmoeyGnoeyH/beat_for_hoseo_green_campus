import 'dart:developer';

import 'package:BEAT/data/provider/register/register_agreement_provider.dart';
import 'package:BEAT/data/provider/register/register_sign_provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'register_college_provider.dart';
import 'register_department_provider.dart';

class RegisterOrganizationProvider{
  static RegisterOrganizationProvider? _instance;

  RegisterOrganizationProvider._internal() {
    organizations = [
      'student'.tr(),
      'faculty_and_staff'.tr(),
      'postgraduate_student'.tr(),
      'other'.tr()
    ];
    organization = organizations.first;
  }

  factory RegisterOrganizationProvider() =>
      _instance ??= RegisterOrganizationProvider._internal();

  factory RegisterOrganizationProvider.init() {
    log('RegisterOrganizationProvider.init');
    return _instance = RegisterOrganizationProvider._internal();
  }

  RegisterCollegeProvider registerCollegeProvider =
      RegisterCollegeProvider(RegisterDepartmentProvider(RegisterSignProvider(RegisterAgreementProvider())));
  late final List<String> organizations;
  String organization = '';

  RegisterDepartmentProvider get registerDepartmentProvider =>
      registerCollegeProvider.registerDepartmentProvider;

  RegisterSignProvider get registerSignProvider => registerDepartmentProvider.registerSignProvider;

  RegisterAgreementProvider get registerAgreementProvider => registerSignProvider.registerAgreementProvider;

  set registerDepartmentProvider(
          RegisterDepartmentProvider registerDepartmentProvider) =>
      registerCollegeProvider.registerDepartmentProvider =
          registerDepartmentProvider;

  void setRegisterDepartmentProviderFromCollege() => registerCollegeProvider
          .registerDepartmentProvider =
      RegisterDepartmentProvider.fromCollege(RegisterSignProvider(RegisterAgreementProvider()), registerCollegeProvider.college);
}
