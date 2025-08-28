import 'package:beat_flutter/managers/localization/localization_manager.dart';

class RegisterCollegeController {
  RegisterCollegeController(
      ) {
    localizationManager = LocalizationManager();
    colleges = localizationManager.colleges;
    college = colleges[0];
  }

  late final LocalizationManager localizationManager;
  // final List<String> colleges = 'colleges'.tr().split(',');
  late final List<String> colleges;
  String college = "";
}
