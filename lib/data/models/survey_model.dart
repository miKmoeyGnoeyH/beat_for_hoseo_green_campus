part of 'data_models.dart';

class SurveyModel extends DataModel {
  SurveyModel({
    required this.surveyId,
    required this.title,
    required this.fromMission,
  });

  SurveyModel.fromJson(Map<String, dynamic> json)
      : surveyId = json['surveyId'],
        title = json['title'],
        fromMission = json['fromMission'];

  final int surveyId;
  final String title;
  final bool fromMission;
}

class SurveyAnswerModel {
  SurveyAnswerModel({
    required this.answerId,
    required this.description,
  });

  SurveyAnswerModel.fromJson(Map<String, dynamic> json)
      : answerId = json['answerId'],
        description = json['description'];

  @override
  String toString() {
    return "{answerId: $answerId, description: $description}";
  }

  final int answerId;
  final String description;
}

class SurveyQuestionModel {
  SurveyQuestionModel({
    required this.surveyQuestionId,
    required this.question,
    required this.answerList,
  });

  SurveyQuestionModel.fromJson(Map<String, dynamic> json)
      : surveyQuestionId = json['surveyQuestionId'],
        question = json['question'],
        answerList = (json['answerList'] as List)
            .map((e) => SurveyAnswerModel.fromJson(e))
            .toList();

  @override
  String toString() {
    return "{surveyQuestionId : $surveyQuestionId, question: $question, answerList: $answerList}";
  }

  final int surveyQuestionId;
  final String question;
  final List<SurveyAnswerModel> answerList;
  int? selectedAnswerIndex;
}

class SurveyDetailModel extends SurveyModel {
  SurveyDetailModel({
    required super.surveyId,
    required super.title,
    required this.questionList,
    super.fromMission = false,
  });

  SurveyDetailModel.fromJson(super.json)
      : questionList = (json['questionList'] as List)
            .map((e) => SurveyQuestionModel.fromJson(e))
            .toList(),
        super.fromJson();

  @override
  String toString() {
    return "SurveyDetailModel(surveyId: $surveyId, title: $title, questionList: $questionList)";
  }

  final List<SurveyQuestionModel> questionList;
}
