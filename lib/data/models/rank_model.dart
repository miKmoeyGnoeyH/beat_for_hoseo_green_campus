part of 'data_models.dart';

class RankModel extends DataModel {
  RankModel(
      {required this.studentId, required this.nickname, required this.neuro});

  RankModel.fromJson(Map<String, dynamic> json)
      : studentId = json['studentId'],
        nickname = json['nickname'],
        neuro = json['neuro'];

  final String studentId;
  final String nickname;
  final int neuro;
}

class RankListModelTest {
  RankListModelTest({
    required this.type,
    required this.data,
  });

  RankListModelTest.fromJson(Map<String, dynamic> json)
      : type = json["type"],
        data = (json["data"] as List)
            .map((item) => RankItemModelTest.fromJson(item))
            .toList();

  final String type;
  final List<RankItemModelTest> data;
}

class RankItemModelTest {
  RankItemModelTest({
    required this.studentId,
    required this.nickname,
    required this.neuro,
  });

  RankItemModelTest.fromJson(Map<String, dynamic> json)
      : studentId = json['studentId'],
        nickname = json['nickname'],
        neuro = json['neuro'];

  final String studentId;
  final String nickname;
  final int neuro;
}

// class RankModelTest extends DataModel {
//   RankModelTest({
//     required this.type,
//     required this.studentId,
//     required this.nickname,
//     required this.neuro,
//   });
//
//   RankModelTest.fromJson(Map<String, dynamic> json)
//       : type = json['type'],
//         studentId = json['studentId'],
//         nickname = json['nickname'],
//         neuro = json['neuro'];
//
//   final String type;
//   final String studentId;
//   final String nickname;
//   final int neuro;
// }
