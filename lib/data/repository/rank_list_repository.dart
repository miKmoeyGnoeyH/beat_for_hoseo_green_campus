import 'dart:developer';

import 'package:beat_flutter/data/models/data_models.dart';
import 'package:beat_flutter/data/provider/rank_list_provider.dart';

class RankListRepository {
  RankListRepository(this.rankListProvider);

  Future<List<RankListModelTest>> getRankListTest() async {
    List<RankListModelTest> retList = [];

    try {
      final List<Map<String, dynamic>> rankListData = await rankListProvider
          .getRankListTest();
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