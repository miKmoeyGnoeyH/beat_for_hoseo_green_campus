part of 'data_models.dart';

class QuestModel extends DataModel {
  QuestModel({
    required this.eventId,
    required this.eventName,
    required this.descriptionShort,
    required this.neuro,
    required this.eventType,
  });

  QuestModel.fromJson(Map<String, dynamic> json)
      : eventId = json['eventId'],
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

class QuestDetailModel extends QuestModel {
  QuestDetailModel({
    required super.eventId,
    required super.eventName,
    required super.descriptionShort,
    required super.neuro,
    required super.eventType,
    required this.eventLocation,
    required this.descriptionLong,
    required this.imageFilePath,
  });

  QuestDetailModel.fromQuestModel(QuestModel questModel, {
    required this.eventLocation,
    required this.descriptionLong,
    required this.imageFilePath,
  }) : super(
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
        super(
        eventId: json['eventId'],
        eventName: json['eventName'],
        descriptionShort: json['descriptionShort'],
        neuro: json['neuro'],
        eventType: json['eventType'],
      );

  QuestDetailModel.fromModelAndJson(QuestModel questModel, Map<String, dynamic> json)
      : eventLocation = json['eventLocation'],
        descriptionLong = json['descriptionLong'],
        imageFilePath = json['imageFilePath'],
        super(
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