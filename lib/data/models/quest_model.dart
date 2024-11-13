part of 'data_models.dart';

class QuestModel extends DataModel {
  factory QuestModel({
    required int eventId,
    required String eventName,
    required String descriptionShort,
    required int neuro,
    required String eventType,
  }) {
    return _cache.putIfAbsent(
        eventId,
        () => QuestModel._internal(
            eventId: eventId,
            eventName: eventName,
            descriptionShort: descriptionShort,
            neuro: neuro,
            eventType: eventType));
  }

  factory QuestModel.fromJson(Map<String, dynamic> json) {
    return _cache.putIfAbsent(
        json['eventId'],
        () => QuestModel._internal(
            eventId: json['eventId'],
            eventName: json['eventName'],
            descriptionShort: json['descriptionShort'],
            neuro: json['neuro'],
            eventType: json['eventType']));
  }

  QuestModel._internal({
    required this.eventId,
    required this.eventName,
    required this.descriptionShort,
    required this.neuro,
    required this.eventType,
  });

  static final Map<int, QuestModel> _cache = {};

  final int eventId;
  final String eventName;
  final String descriptionShort;
  final int neuro;
  final String? eventType;
}

class QuestVoteResultModel extends QuestModel {
  QuestVoteResultModel({
    required super.eventId,
    required super.eventName,
    required super.descriptionShort,
    required this.result,
    required this.voteNeuro,
    required this.earnedNeuro,
    required String super.eventType,
  }) : super._internal(
            neuro: 0);

  QuestVoteResultModel.fromJson(Map<String, dynamic> json)
      : result = json['result'],
        voteNeuro = json['VoteNeuro'] ?? 0,
        earnedNeuro = json['earnedNeuro'],
        super._internal(
          eventId: json['eventId'],
          eventName: json['eventName'],
          descriptionShort: json['descriptionShort'],
          neuro: 0,
          eventType: json['eventType'],
        );

  QuestVoteResultModel.fromQuestModel(QuestModel questModel,
      {required this.result,
      required this.voteNeuro,
      required this.earnedNeuro})
      : super._internal(
          eventId: questModel.eventId,
          eventName: questModel.eventName,
          descriptionShort: questModel.descriptionShort,
          neuro: questModel.neuro,
          eventType: questModel.eventType,
        );

  QuestVoteResultModel.fromModelAndJson(
      QuestModel questModel, Map<String, dynamic> json)
      : result = json['result'],
        voteNeuro = json['VoteNeuro'],
        earnedNeuro = json['earnedNeuro'],
        super._internal(
          eventId: questModel.eventId,
          eventName: questModel.eventName,
          descriptionShort: questModel.descriptionShort,
          neuro: questModel.neuro,
          eventType: questModel.eventType,
        );

  final String result;
  final int voteNeuro;
  final int earnedNeuro;
}

class QuestDetailModel extends QuestModel {
  QuestDetailModel({
    required super.eventId,
    required super.eventName,
    required super.descriptionShort,
    required super.neuro,
    required String super.eventType,
    required this.eventLocation,
    required this.descriptionLong,
    required this.imageFilePath,
  }) : super._internal();

  QuestDetailModel.fromQuestModel(
    QuestModel questModel, {
    required this.eventLocation,
    required this.descriptionLong,
    required this.imageFilePath,
  }) : super._internal(
          eventId: questModel.eventId,
          eventName: questModel.eventName,
          descriptionShort: questModel.descriptionShort,
          neuro: questModel.neuro,
          eventType: questModel.eventType,
        );

  QuestDetailModel.fromJson(Map<String, dynamic> json)
      : eventLocation = json['eventLocation'],
        descriptionLong = json['descriptionLong'],
        imageFilePath = json['imageFilePath'],
        super._internal(
          eventId: json['eventId'],
          eventName: json['eventName'],
          descriptionShort: json['descriptionShort'],
          neuro: json['neuro'],
          eventType: json['eventType'],
        );

  QuestDetailModel.fromModelAndJson(
      QuestModel questModel, Map<String, dynamic> json)
      : eventLocation = json['eventLocation'],
        descriptionLong = json['descriptionLong'],
        imageFilePath = json['imageFilePath'],
        super._internal(
          eventId: questModel.eventId,
          eventName: questModel.eventName,
          descriptionShort: questModel.descriptionShort,
          neuro: questModel.neuro,
          eventType: questModel.eventType,
        );

  final String eventLocation;
  final String descriptionLong;
  final String? imageFilePath;
}
