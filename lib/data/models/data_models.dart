part 'quest_model.dart';
part 'quiz_model.dart';

abstract class DataModel {
  DataModel();

  DataModel.fromJson(Map<String, dynamic> json);
}

class SurveyModel extends DataModel {
  SurveyModel({required this.surveyId, required this.title});

  SurveyModel.fromJson(Map<String, dynamic> json)
      : surveyId = json['surveyId'],
        title = json['title'];

  final int surveyId;
  final String title;
}