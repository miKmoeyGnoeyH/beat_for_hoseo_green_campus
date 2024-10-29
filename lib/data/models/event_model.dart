class QuestModel {
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

sealed class QuestsState {
  QuestsState([this.quests = const []]);

  final List<QuestModel> quests;
}

final class QuestsInitial extends QuestsState {
  QuestsInitial();
}

final class QuestsLoading extends QuestsState {
  QuestsLoading();
}

final class QuestsLoadingError extends QuestsState {
  QuestsLoadingError();
}

final class QuestsLoadingSuccess extends QuestsState {
  QuestsLoadingSuccess(super.quests);
}