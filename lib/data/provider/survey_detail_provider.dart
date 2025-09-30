import 'dart:convert';

import 'package:beat_flutter/exception/beat_exception.dart';
import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/logger/beat_logger.dart';
import 'package:http/http.dart' as http;

class SurveyDetailProvider {
  final LocalizationManager localizationManager = LocalizationManager();

  Future<Map<String, dynamic>> fetchSurveyDetail(
      int surveyId, String authorization) async {
    final String requestURL = "${DotEnvManager().surveyDetail}$surveyId";

    BEATLogger.d(
        "SurveyDetailProvider : fetchSurveyDetail : requestURL : $requestURL");

    try {
      final http.Response response = await http.get(
        Uri.parse(requestURL),
        headers: {"Authorization": authorization},
      ).timeout(
        const Duration(seconds: 5),
      );

      BEATLogger.d(
          "SurveyDetailProvider : fetchSurveyDetail : response.body : ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw BEATException(
          localizationManager.sdFetchSurveyFailedTitle,
          localizationManager.sdFetchSurveyFailedContent,
        );
      }
    } catch (e) {
      BEATLogger.d(
          "SurveyDetailProvider : fetchSurveyDetail : error : ${e.toString()}");
      rethrow;
    }

    return {};
  }
}
