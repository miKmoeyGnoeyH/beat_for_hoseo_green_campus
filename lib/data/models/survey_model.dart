part of 'data_models.dart';

class SurveyModel extends DataModel {
  SurveyModel({required this.surveyId, required this.title});

  SurveyModel.fromJson(Map<String, dynamic> json)
      : surveyId = json['surveyId'],
        title = json['title'];

  final int surveyId;
  final String title;
}