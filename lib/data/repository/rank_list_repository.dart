import 'dart:developer';

import 'package:beat_flutter/data/models/data_models.dart';
import 'package:beat_flutter/data/provider/rank_list_provider.dart';

class RankListRepository {
  RankListRepository(this.rankListProvider);

  Future<RankListModel> getRankList(String authorization) async {
    try {
      final Map<String, dynamic> rankListData = await rankListProvider
          .getRankList(authorization);
      
      log("RankListRepository: getRankList: rankListData: $rankListData");
      
      return RankListModel.fromJson(rankListData);
    } catch (e) {
      log("RankListRepository : getRankList : error : $e");
      rethrow;
    }
  }

  Future<List<RankListModelTest>> getRankListTest(String authorization) async {
    List<RankListModelTest> retList = [];

    try {
      final List<Map<String, dynamic>> rankListData = await rankListProvider
          .getRankListTest(authorization);
      for (var data in rankListData) {
        retList.add(RankListModelTest.fromJson(data));
      }
    } catch (e) {
      log("RankListRepository : getRankList : error : $e");
      rethrow;
    }
    return retList;
  }

  final RankListProvider rankListProvider;
}