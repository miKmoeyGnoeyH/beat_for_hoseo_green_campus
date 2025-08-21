import 'package:beat_flutter/components/global/widgets/buttons/custom_wide_button.dart';
import 'package:beat_flutter/components/rank/widgets/ranking_card.dart';
import 'package:beat_flutter/components/rank/widgets/ranking_point_list.dart';
import 'package:beat_flutter/controller/rank/rank_controller_test.dart';
import 'package:beat_flutter/data/provider/rank_list_provider.dart';
import 'package:beat_flutter/data/repository/rank_list_repository.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/theme/texts/custom_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../controller/rank/rank_controller.dart';
import '../../data/states/data_list_state.dart';
import '../global/widgets/appbars/custom_empty_appbar.dart';
import '../global/widgets/buttons/custom_refresh_button.dart';
import '../global/widgets/custom_circular_progress_indicator.dart';
import '../global/widgets/custom_scaffold.dart';
import '../global/widgets/texts/custom_body_large.dart';
import '../global/widgets/texts/custom_display_medium.dart';
import 'widgets/ranking_list_view.dart';

class RankingScreen extends StatefulWidget {
  RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final RankControllerTest rankControllerTest =
      Get.put(RankControllerTest(RankListRepository(RankListProvider())));

  final LocalizationManager localizationManager = LocalizationManager();

  final PageController pageController = PageController();

  int currentIndex = 0;

  @override
  void initState() {
    rankControllerTest.fetchRankList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final RankController rankController = context.read<RankController>();
    return CustomScaffold(
      appBar: const CustomEmptyAppBar(),
      body: NestedScrollView(
        headerSliverBuilder: (context, inner) => [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomDisplayMedium(
                      text: localizationManager.rankingRanking,
                      textColor: context.appColors.defaultTextColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // TODO: 예외처리
                  Obx(
                    () => rankControllerTest.rankList.isEmpty
                        ? const SizedBox.shrink()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 50,
                                child: ListView.separated(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (_, index) => CustomWideButton(
                                    autoSizeText: false,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 16),
                                    buttonText: getButtonTextByRankType(
                                      rankControllerTest.rankList[index].type,
                                    ),
                                    buttonTextStyle: CustomTexts.bodyLarge,
                                    textColor: index == currentIndex
                                        ? context.appColors.onPrimary
                                        : context.appColors.defaultTextColor,
                                    buttonColor: index == currentIndex
                                        ? context.appColors.primary
                                        : context.appColors.background,
                                    onTap: () => onButtonTap(index),
                                  ),
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 10),
                                  itemCount: rankControllerTest.rankList.length,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: CustomBodyLarge(
                                  text: getDescByRankType(rankControllerTest
                                      .rankList[currentIndex].type),
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
        body: Obx(
          () => rankControllerTest.rankList.isEmpty
              ? const SizedBox.shrink()
              : PageView(
                  controller: pageController,
                  onPageChanged: onPageChanged,
                  children: rankControllerTest.rankList.map((rankList) {
                    return ListView.separated(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 16),
                      itemCount: rankList.data.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, index) =>
                          RankingCard(rankList.data[index], index + 1),
                    );
                  }).toList(),
                ),
        ),
      ),
    );
  }

  List<Widget> get rankingListWidgets =>
      rankControllerTest.rankList.map((rankList) {
        return ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rankList.data.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) =>
              RankingCard(rankList.data[index], index + 1),
        );
      }).toList();

  String getButtonTextByRankType(String type) {
    switch (type) {
      case 'point':
        return localizationManager.rankingPoint;
      case 'step':
        return localizationManager.rankingStepCount;
      default:
        return type;
    }
  }

  String getDescByRankType(String type) {
    switch (type) {
      case 'point':
        return localizationManager.rankingRankingDescPoint;
      case 'step':
        return localizationManager.rankingRankingDescStepCount;
      default:
        return '';
    }
  }

  void onButtonTap(int index) {
    setState(() {
      currentIndex = index;
    });
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
