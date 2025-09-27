import 'package:beat_flutter/data/models/my_page_models.dart';
import 'package:beat_flutter/data/provider/my_page_provider.dart';

class MyPageRepository {
  Future<MyPageModel> getMyPage(String authorization) async {
    try {
      final Map<String, dynamic> myRankJson = await myPageProvider.getMyRank(authorization);
      final MyRankModel myRankModel = MyRankModel.fromJson(myRankJson);

      final Map<String, dynamic> walkMeanHistoryJson = await myPageProvider.getWalkMeanHistory(authorization);
      final WalkMeanHistoryModel walkMeanHistoryModel = WalkMeanHistoryModel.fromJson(walkMeanHistoryJson);

      return MyPageModel(myRankModel, walkMeanHistoryModel);
    } catch (e) {
      rethrow;
    }
  }

  Future<MyRankModel> getMyRank(String authorization) async {
    try {
      final Map<String, dynamic> response =
      await myPageProvider.getMyRank(authorization);
      return MyRankModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<WalkMeanHistoryModel> getWalkMeanHistory(String authorization) async {
    try {
      final Map<String, dynamic> response =
      await myPageProvider.getMyRank(authorization);
      return WalkMeanHistoryModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  final MyPageProvider myPageProvider = MyPageProvider();
}