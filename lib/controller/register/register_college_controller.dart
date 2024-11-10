import 'package:easy_localization/easy_localization.dart';

class RegisterCollegeController {
  RegisterCollegeController();

  final List<String> colleges = 'colleges'.tr().split(',');
  String college = 'colleges'.tr().split(',')[0];
}
