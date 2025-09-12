import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageIndexController extends GetxController {
  final Rx<int> _selectedIndex = 1.obs;
  int get selectedIndex => _selectedIndex.value;
  set selectedIndex(int index) => _selectedIndex.value = index;

  final int homeIndex = 1;

  void setIndex(int index) {
    selectedIndex = index;

    if (selectedIndex != homeIndex) {
      scrollController.jumpTo(0);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  final ScrollController scrollController = ScrollController();
}