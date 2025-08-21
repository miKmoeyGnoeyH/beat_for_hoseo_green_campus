import 'dart:developer';

import 'package:beat_flutter/data/models/data_models.dart';
import 'package:beat_flutter/data/repository/rank_list_repository.dart';
import 'package:get/get.dart';

class RankControllerTest extends GetxController {
  RankControllerTest(this.rankListRepository);
  final RxList<RankListModelTest> _rankList = <RankListModelTest>[].obs;
  List<RankListModelTest> get rankList => _rankList;
  set rankList(List<RankListModelTest> value) => _rankList.value = value;

  Future<void> fetchRankList() async {
    try {
      final List<RankListModelTest> list = await rankListRepository.getRankListTest();
      rankList = list;
    } catch (e) {
      rankList = [];
      log("Error fetching rank list: $e");
    }
  }

  final RankListRepository rankListRepository;
}