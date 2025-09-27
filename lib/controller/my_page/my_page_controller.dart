import 'dart:developer';

import 'package:beat_flutter/data/models/my_page_models.dart';
import 'package:beat_flutter/data/repository/my_page_repository.dart';
import 'package:get/get.dart';

class MyPageController extends GetxController with StateMixin {
  RankControllerTest() {
    change(null, status: RxStatus.empty());
  }

  Future<void> getMyPageData(String authorization) async {
    change(null, status: RxStatus.loading());

    try {
      final MyPageModel myPageModel = await myPageRepository.getMyPage(authorization);
      change(myPageModel, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
      rethrow;
    }
  }

  final MyPageRepository myPageRepository = MyPageRepository();
}
