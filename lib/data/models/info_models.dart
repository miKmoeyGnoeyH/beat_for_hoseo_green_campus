part of 'data_models.dart';

class InfoList {
  InfoList({
    required this.earnings,
    required this.spending,
  });

  InfoList.fromJson(Map<String, dynamic> json)
      : earnings = (json['earnings'] as List)
            .map((info) => InfoModel.fromJson(info))
            .toList(),
        spending = (json['spending'] as List)
            .map((info) => InfoModel.fromJson(info))
            .toList();

  final List<InfoModel> earnings;
  final List<InfoModel> spending;
}

class InfoModel extends DataModel {
  InfoModel({
    required this.event,
    required this.location,
    required this.neuro_points,
  });

  InfoModel.fromJson(Map<String, dynamic> json)
      : event = json['event'],
        location = json['location'],
        neuro_points = json['neuro_points'];

  final String event;
  final String location;
  final String neuro_points;
}
