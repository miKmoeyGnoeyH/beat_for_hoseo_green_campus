import 'data_models.dart';

class RankModel extends DataModel{
  RankModel({required this.studentId, required this.nickname, required this.neuro});
  RankModel.fromJson(Map<String, dynamic> json)
      : studentId = json['studentId'],
        nickname = json['nickname'],
        neuro = json['neuro'];

  final String studentId;
  final String nickname;
  final int neuro;
}