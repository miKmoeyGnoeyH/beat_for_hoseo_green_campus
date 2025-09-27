class MyPageModel {
  MyPageModel(this.myRankModel, this.walkMeanHistoryModel);

  final MyRankModel myRankModel;
  final WalkMeanHistoryModel walkMeanHistoryModel;
}

class MyRankModel {
  MyRankModel({
    required this.point,
    required this.pointRank,
    required this.pointCategoryRank,
    required this.walk,
    required this.walkRank,
    required this.walkCategoryRank,
  });

  MyRankModel.fromJson(Map<String, dynamic> json)
      : point = json['point'] as int,
        pointRank = json['pointRank'] as int,
        pointCategoryRank = json['pointCategoryRank'] as int,
        walk = json['walk'] as int,
        walkRank = json['walkRank'] as int,
        walkCategoryRank = json['walkCategoryRank'] as int;

  final int point;
  final int pointRank;
  final int pointCategoryRank;
  final int walk;
  final int walkRank;
  final int walkCategoryRank;
}

class WalkMeanHistoryModel {
  WalkMeanHistoryModel({
    required this.todayWalkCount,
    required this.weeklyWalkCount,
    required this.monthlyWalkCount,
    required this.totalWalkCount,
  });

  WalkMeanHistoryModel.fromJson(Map<String, dynamic> json)
      : todayWalkCount = json['todayWalkCount'] as int,
        weeklyWalkCount = json['weeklyWalkCount'] as int,
        monthlyWalkCount = json['monthlyWalkCount'] as int,
        totalWalkCount = json['totalWalkCount'] as int;

  final int todayWalkCount;
  final int weeklyWalkCount;
  final int monthlyWalkCount;
  final int totalWalkCount;
}