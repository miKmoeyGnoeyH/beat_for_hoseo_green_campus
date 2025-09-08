part of 'data_models.dart';

enum EventType {
  qr("QR"),
  walk("WALK");

  const EventType(this.eventType);

  static EventType fromString(String eventType) {
    return EventType.values.firstWhere(
      (e) => e.eventType == eventType,
      orElse: () => throw ArgumentError('Invalid event type: $eventType'),
    );
  }

  final String eventType;
}

enum EventPeriodType {
  // json 필드값 변경
  daily("DAILY"),
  weekly("WEEKLY"),
  monthly("MONTHLY");

  const EventPeriodType(this.eventPeriodType);

  static EventPeriodType fromString(String eventPeriodType) {
    return EventPeriodType.values.firstWhere(
      (e) => e.eventPeriodType == eventPeriodType,
      orElse: () =>
          throw ArgumentError('Invalid event period type: $eventPeriodType'),
    );
  }

  final String eventPeriodType;
}

// 퀘스트 모델(홈에서 보여짐)
sealed class QuestModel extends DataModel {
  QuestModel({
    required this.eventId,
    required this.eventName,
    required this.descriptionShort,
    required this.neuro,
    required this.eventType,
    required this.hasSuccess,
  });

  factory QuestModel.fromJson(Map<String, dynamic> json) {
    final EventType eventType = EventType.fromString(json['eventType']);
    switch (eventType) {
      case EventType.qr:
        return QuestQRModel.fromJson(json);
      case EventType.walk:
        return QuestWalkModel.fromJson(json);
    }
  }

  final int eventId;
  final String eventName;
  final String descriptionShort;
  final int neuro;
  final EventType eventType;
  final bool hasSuccess;
}

class QuestQRModel extends QuestModel {
  QuestQRModel({
    required super.eventId,
    required super.eventName,
    required super.descriptionShort,
    required super.neuro,
    required super.eventType,
    required super.hasSuccess,
    required this.requiredCount,
    required this.successCount,
    required this.totalCount,
  });

  QuestQRModel.fromJson(Map<String, dynamic> json)
      : requiredCount = json['requiredCount'],
        successCount = json['successCount'],
        totalCount = json['totalCount'],
        super(
          eventId: json['eventId'],
          eventName: json['eventName'],
          descriptionShort: json['descriptionShort'],
          neuro: json['neuro'],
          eventType: EventType.fromString(json['eventType']),
          hasSuccess: json['hasSuccess'] ?? false,
        );

  final int requiredCount;
  final int successCount;
  final int totalCount;
}

class QuestWalkModel extends QuestModel {
  QuestWalkModel({
    required super.eventId,
    required super.eventName,
    required super.descriptionShort,
    required super.neuro,
    required super.eventType,
    required super.hasSuccess,
    required this.requiredWalkCount,
    required this.eventPeriodType,
  });

  QuestWalkModel.fromJson(Map<String, dynamic> json)
      : requiredWalkCount = json['requiredWalkCount'],
        // json 필드명 변경
        eventPeriodType = EventPeriodType.fromString(json['period']),
        super(
          eventId: json['eventId'],
          eventName: json['eventName'],
          descriptionShort: json['descriptionShort'],
          neuro: json['neuro'],
          eventType: EventType.fromString(json['eventType']),
          hasSuccess: json['hasSuccess'] ?? false,
        );

  final int requiredWalkCount;
  final EventPeriodType eventPeriodType;
}

// 투표 결과 퀘스트 모델(안씀)
class QuestVoteResultModel extends QuestModel {
  QuestVoteResultModel({
    required super.eventId,
    required super.eventName,
    required super.descriptionShort,
    required this.result,
    required this.voteNeuro,
    required this.earnedNeuro,
    required super.eventType,
  }) : super(neuro: 0, hasSuccess: false);

  QuestVoteResultModel.fromJson(Map<String, dynamic> json)
      : result = json['result'],
        voteNeuro = json['VoteNeuro'] ?? 0,
        earnedNeuro = json['earnedNeuro'],
        super(
          eventId: json['eventId'],
          eventName: json['eventName'],
          descriptionShort: json['descriptionShort'],
          neuro: 0,
          eventType: json['eventType'],
          hasSuccess: false,
        );

  QuestVoteResultModel.fromQuestModel(QuestModel questModel,
      {required this.result,
      required this.voteNeuro,
      required this.earnedNeuro})
      : super(
          eventId: questModel.eventId,
          eventName: questModel.eventName,
          descriptionShort: questModel.descriptionShort,
          neuro: questModel.neuro,
          eventType: questModel.eventType,
          hasSuccess: questModel.hasSuccess,
        );

  QuestVoteResultModel.fromModelAndJson(
      QuestModel questModel, Map<String, dynamic> json)
      : result = json['result'],
        voteNeuro = json['VoteNeuro'],
        earnedNeuro = json['earnedNeuro'],
        super(
          eventId: questModel.eventId,
          eventName: questModel.eventName,
          descriptionShort: questModel.descriptionShort,
          neuro: questModel.neuro,
          eventType: questModel.eventType,
          hasSuccess: questModel.hasSuccess,
        );

  final String result;
  final int voteNeuro;
  final int earnedNeuro;
}

class QRMissionDTO {
  QRMissionDTO({
    required this.qrMissionID,
    required this.eventQRName,
    required this.qrLocation,
    required this.qrRewardPoint,
  });

  QRMissionDTO.fromJson(Map<String, dynamic> json)
      : qrMissionID = json['qrMissionId'],
        eventQRName = json['eventQrName'],
        qrLocation = json['qrLocation'],
        qrRewardPoint = json['qrRewardNeuro'];

  final int qrMissionID;
  final String eventQRName;
  final String qrLocation;
  final int qrRewardPoint;
}

class QRMissionLongDTO {
  QRMissionLongDTO({
    required this.successCondition,
    required this.successPoint,
    required this.qrMissionDTOList,
  });

  QRMissionLongDTO.fronJson(Map<String, dynamic> json)
      : successCondition = json['successCondition'],
        successPoint = json['successNeuro'],
        qrMissionDTOList = (json['qrMissionDtoList'] as List)
            .map((e) => QRMissionDTO.fromJson(e))
            .toList();

  final int successCondition;
  final int successPoint;
  final List<QRMissionDTO> qrMissionDTOList;
}

class EventLongDTO {}

class EventQRLongDTO extends EventLongDTO {
  EventQRLongDTO({
    required this.hasReward,
    required this.qrMissionLongDTO,
  });

  EventQRLongDTO.fromJson(Map<String, dynamic> json)
      : hasReward = json['hasReward'],
        qrMissionLongDTO = QRMissionLongDTO.fronJson(json['qrMissionLongDto']);

  final bool hasReward;
  final QRMissionLongDTO qrMissionLongDTO;
}

class EventWalkLongDTO extends EventLongDTO {
  EventWalkLongDTO({
    required this.period,
    required this.walkCount,
  });

  EventWalkLongDTO.fromJson(Map<String, dynamic> json)
      : period = json['period'],
        walkCount = json['walkCount'];

  final String period;
  final int walkCount;
}

class QuestDetailModel extends QuestModel {
  QuestDetailModel({
    required super.eventId,
    required super.eventName,
    required this.descriptionLong,
    required super.neuro,
    required super.eventType,
    required this.startDate,
    required this.endDate,
    // required this.eventLocation,
    required this.hasImage,
    required this.eventLongDTO,
  }) : super(descriptionShort: "", hasSuccess: false);

  QuestDetailModel.fromJson(Map<String, dynamic> json, this.hasImage)
      : descriptionLong = json['descriptionLong'],
        startDate = DateTime.parse(json['startDate']),
        endDate = DateTime.parse(json['endDate']),
        eventLongDTO = EventType.fromString(json['eventType']) == EventType.qr
            ? EventQRLongDTO.fromJson(json['eventLongDto'])
            : EventWalkLongDTO.fromJson(json['eventLongDto']),
        super(
          eventId: json['eventId'],
          eventName: json['eventName'],
          descriptionShort: json['descriptionShort'] ?? "",
          neuro: json['neuro'],
          eventType: EventType.fromString(json['eventType']),
          hasSuccess: json['hasSuccess'] ?? false,
        );

  // eventLocation = json['eventLocation'],
  // eventLocation = json['eventLocation'],

  // final String eventLocation;
  final String descriptionLong;
  final DateTime startDate;
  final DateTime endDate;

  final bool hasImage;
  final EventLongDTO eventLongDTO;
}
