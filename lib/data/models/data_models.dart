abstract class DataModel {
  DataModel();
  DataModel.fromJson(Map<String, dynamic> json);
}

class QuestModel extends DataModel {
  QuestModel({
    required this.eventId,
    required this.eventName,
    required this.descriptionShort,
    required this.neuro,
    required this.eventType,
  });

  QuestModel.fromJson(Map<String, dynamic> json) :
    eventId = json['eventId'],
    eventName = json['eventName'],
    descriptionShort = json['descriptionShort'],
    neuro = json['neuro'],
    eventType = json['eventType'];

  final int eventId;
  final String eventName;
  final String descriptionShort;
  final int neuro;
  final String? eventType;
}

class QuizModel extends DataModel {
  QuizModel({
    required this.quizId,
    required this.title,
    required this.content,
    required this.neuro,
    required this.alreadySolved,
  });

  QuizModel.fromJson(Map<String, dynamic> json) :
    quizId = json['quizId'],
    title = json['title'],
    content = json['content'],
    neuro = json['neuro'],
    alreadySolved = json['alreadySolved'];

  final int quizId;
  final String title;
  final String content;
  final int neuro;
  final bool alreadySolved;
}