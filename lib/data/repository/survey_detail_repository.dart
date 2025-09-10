import 'package:beat_flutter/data/models/data_models.dart';
import 'package:beat_flutter/data/provider/survey_detail_provider.dart';
import 'package:beat_flutter/exception/beat_exception.dart';
import 'package:beat_flutter/managers/logger/beat_logger.dart';

class SurveyDetailRepository {
  Future<SurveyDetailModel> fetchSurveyDetail(int surveyId) async {
    try {
      final response = await surveyDetailProvider.fetchSurveyDetail(surveyId);
      return SurveyDetailModel.fromJson(response);
    } on BEATException {
      rethrow;
    } catch (e) {
      BEATLogger.d("SurveyDetailRepository : fetchSurveyDetail : error : ${e.toString()}");
      rethrow;
    }
  }

  final SurveyDetailProvider surveyDetailProvider = SurveyDetailProvider();
}