part of 'data_models.dart';

class VoteModel extends DataModel {
  VoteModel(
      {required this.bettingId,
      required this.bettingName,
      required this.gatheredNeuro,
      required this.bettingEndTime,
      required this.bettingStatus});

  VoteModel.fromJson(Map<String, dynamic> json)
      : bettingId = json['bettingId'],
        bettingName = json['bettingName'],
        gatheredNeuro = json['gatheredNeuro'],
        bettingEndTime = json['bettingEndTime'],
        bettingStatus = json['bettingStatus'];

  VoteModel.fromModel(VoteModel voteModel)
      : bettingId = voteModel.bettingId,
        bettingName = voteModel.bettingName,
        gatheredNeuro = voteModel.gatheredNeuro,
        bettingEndTime = voteModel.bettingEndTime,
        bettingStatus = voteModel.bettingStatus;

  final int? bettingId;
  final String? bettingName;
  final int? gatheredNeuro;
  final String? bettingEndTime;
  final String? bettingStatus;
}

class VoteResultModel extends VoteModel {
  VoteResultModel(
      {required super.bettingId,
      required super.bettingName,
      required super.gatheredNeuro,
      required super.bettingEndTime,
      required super.bettingStatus,
      required this.eventType,
      required this.bettingEventList,
      required this.bettingStartTime});

  VoteResultModel.fromJson(super.json)
      : eventType = json['eventType'],
        bettingEventList = json['bettingEventList'],
        bettingStartTime = json['bettingStartTime'],
        super.fromJson();

  VoteResultModel.fromModel(super.voteModel,
      {required this.eventType,
      required this.bettingEventList,
      required this.bettingStartTime})
      : super.fromModel();

  VoteResultModel.fromModelAndJson(super.voteModel, Map<String, dynamic> json)
      : bettingEventList = (json['bettingEventList'] as List)
            .map((bettingEvent) => QuestVoteResultModel.fromJson(bettingEvent))
            .toList(),
        eventType = json['eventType'],
        bettingStartTime = json['bettingStartTime'],
        super.fromModel();

  final String? eventType;
  final List<QuestVoteResultModel> bettingEventList;
  final String? bettingStartTime;
}

class VoteDetailModel extends VoteModel {
  VoteDetailModel(
      {required super.bettingId,
      required super.bettingName,
      required super.gatheredNeuro,
      required super.bettingEndTime,
      required super.bettingStatus,
      required this.eventType,
      required this.bettingEventList,
      required this.bettingStartTime});

  VoteDetailModel.fromJson(super.json)
      : eventType = json['eventType'],
        bettingEventList = json['bettingEventList'],
        bettingStartTime = json['bettingStartTime'],
        super.fromJson();

  VoteDetailModel.fromModel(super.voteModel,
      {required this.eventType,
      required this.bettingEventList,
      required this.bettingStartTime})
      : super.fromModel();

  VoteDetailModel.fromModelAndJson(super.voteModel, Map<String, dynamic> json)
      : bettingEventList = (json['bettingEventList'] as List)
            .map((bettingEvent) => QuestModel.fromJson(bettingEvent))
            .toList(),
        eventType = json['eventType'],
        bettingStartTime = json['bettingStartTime'],
        super.fromModel();

  final String? eventType;
  final List<QuestModel> bettingEventList;
  final String? bettingStartTime;
}
