
import 'package:beat_flutter/controller/reset_password/reset_password_controller.dart';

import '../../../controller/register/register_college_controller.dart';
import '../../../controller/register/register_department_controller.dart';
import '../../../controller/register/register_organization_controller.dart';

class ResetPasswordArguments {
  ResetPasswordArguments({
    required this.resetPasswordController,
  });

  final ResetPasswordController resetPasswordController;
}