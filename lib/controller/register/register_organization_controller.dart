import 'package:easy_localization/easy_localization.dart';

class RegisterOrganizationController {
  RegisterOrganizationController();

  final List<String> organizations = [
    'student'.tr(),
    'faculty_and_staff'.tr(),
    'postgraduate_student'.tr(),
    'other'.tr()
  ];
  String organization = 'student'.tr();
}
