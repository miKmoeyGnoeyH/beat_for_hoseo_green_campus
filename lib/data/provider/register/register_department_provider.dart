import 'package:BEAT/data/provider/register/register_sign_provider.dart';
import 'package:easy_localization/easy_localization.dart';

class RegisterDepartmentProvider {
  RegisterDepartmentProvider(this.registerSignProvider);
  RegisterDepartmentProvider.fromCollege(this.registerSignProvider, String college) {
    departments = 'departments'.tr(gender: college).split(', ');
    department = departments.first;
  }

  RegisterSignProvider registerSignProvider;
  List<String> departments = [];
  String department = '';
}