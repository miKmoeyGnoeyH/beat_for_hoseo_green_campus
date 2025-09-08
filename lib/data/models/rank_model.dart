part of 'data_models.dart';

class RankModel extends DataModel {
  RankModel(
      {required this.studentId, required this.nickname, required this.num});

  RankModel.fromJson(Map<String, dynamic> json)
      : studentId = json['studentId'],
        nickname = json['nickname'],
        num = json['num'];

  final String studentId;
  final String nickname;
  final int num;
}

class RankListModel {
  RankListModel({
    required this.data,
  });

  RankListModel.fromJson(Map<String, dynamic> json)
      : data = Map.fromEntries(
          json.entries.map(
            (entry) => MapEntry(
              entry.key,
              (entry.value as List)
                  .map((item) => RankItemModel.fromJson(item))
                  .toList(),
            ),
          ),
        );

  RankListModel.empty() : data = {};

  final Map<String, List<RankItemModel>> data;
}

class RankListModelTest {
  RankListModelTest({
    required this.pointRankerList,
    required this.pointCategoryRankerList,
    required this.walkRankerList,
    required this.walkCategoryRankerList,
  });

  RankListModelTest.fromJson(Map<String, dynamic> json)
      : pointRankerList = (json["pointRankerList"] as List)
            .map((item) => RankItemModel.fromJson(item))
            .toList(),
        pointCategoryRankerList = (json["pointCategoryRankerList"] as List)
            .map((item) => RankItemModel.fromJson(item))
            .toList(),
        walkRankerList = (json["walkRankerList"] as List)
            .map((item) => RankItemModel.fromJson(item))
            .toList(),
        walkCategoryRankerList = (json["walkCategoryRankerList"] as List)
            .map((item) => RankItemModel.fromJson(item))
            .toList();

  final List<RankItemModel> pointRankerList;
  final List<RankItemModel> pointCategoryRankerList;
  final List<RankItemModel> walkRankerList;
  final List<RankItemModel> walkCategoryRankerList;
}

class RankItemModel {
  RankItemModel({
    required this.studentId,
    required this.nickname,
    required this.num,
  });

  RankItemModel.fromJson(Map<String, dynamic> json)
      : studentId = json['studentId'],
        nickname = json['nickname'],
        num = json['num'];

  final String studentId;
  final String nickname;
  final int num;
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
