part of 'data_models.dart';

class NotificationModel extends DataModel {
  NotificationModel(
      {required this.noticeId,
      required this.title,
      required this.body,
      required this.createdAt});

  NotificationModel.fromJson(Map<String, dynamic> json)
      : noticeId = json["noticeId"],
        title = json["title"],
        body = json["body"],
        createdAt = DateTime.parse(json["createdAt"]);

  final int noticeId;
  final String title;
  final String body;
  final DateTime createdAt;
}
