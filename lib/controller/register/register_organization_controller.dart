import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:easy_localization/easy_localization.dart';

class RegisterOrganizationController {
  RegisterOrganizationController() {
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
