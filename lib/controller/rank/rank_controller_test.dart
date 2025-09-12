import 'dart:async';
import 'dart:developer';

import 'package:beat_flutter/data/models/data_models.dart';
import 'package:beat_flutter/data/repository/rank_list_repository.dart';
import 'package:get/get.dart';

class RankControllerTest extends GetxController with StateMixin<RankListModel> {
  RankControllerTest(this.rankListRepository, this.authorization) {
    change(null, status: RxStatus.empty());
  }

  // final Rx<RankListModel> _rankList = RankListModel.empty().obs;
  // RankListModel get rankList => _rankList.value;
  // set rankList(RankListModel value) => _rankList.value = value;

  Future<void> fetchRankList() async {
    change(null, status: RxStatus.loading());

    await Future.delayed(const Duration(seconds: 5), () {
      change(null, status: RxStatus.error(""));
      throw TimeoutException("");
    });

    try {
      // final List<RankListModelTest> list = await rankListRepository.getRankListTest();
      final RankListModel rankListModel = await rankListRepository.getRankList(authorization);
      change(rankListModel, status: RxStatus.success());
      // rankList = rankListModel;
    } catch (e) {
      // log("Error fetching rank list: $e");
      change(null, status: RxStatus.error(e.toString()));
      rethrow;
      // rankList = RankListModel.empty();
    }
  }

  final RankListRepository rankListRepository;
  final String authorization;
}
