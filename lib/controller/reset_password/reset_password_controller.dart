import 'package:beat_flutter/managers/localization/localization_manager.dart';

class ResetPasswordController {
  ResetPasswordController() {
    final LocalizationManager localizationManager = LocalizationManager();
    organizations = [
      localizationManager.roStudent,
      localizationManager.roFacultyAndStaff
    ];
    organization = organizations.first;
  }
  late final List<String> organizations;
  String organization = "";
}
