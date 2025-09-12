import 'dart:developer';

import 'package:beat_flutter/components/global/widgets/buttons/custom_refresh_button.dart';
import 'package:beat_flutter/components/global/widgets/buttons/custom_wide_button.dart';
import 'package:beat_flutter/components/global/widgets/custom_circular_progress_indicator.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_headline_small.dart';
import 'package:beat_flutter/components/rank/widgets/ranking_card.dart';
import 'package:beat_flutter/controller/rank/rank_controller_test.dart';
import 'package:beat_flutter/controller/user_controller.dart';
import 'package:beat_flutter/data/models/data_models.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/theme/texts/custom_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../global/widgets/appbars/custom_empty_appbar.dart';
import '../global/widgets/custom_scaffold.dart';
import '../global/widgets/texts/custom_body_large.dart';
import '../global/widgets/texts/custom_display_medium.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final RankControllerTest rankListController = Get.find<RankControllerTest>();

  final LocalizationManager localizationManager = LocalizationManager();

  final PageController pageController = PageController();

  final ScrollController scrollController = ScrollController();

  int currentIndex = 0;

  @override
  void initState() {
    // rankListController.fetchRankList();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      rankListController.fetchRankList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomEmptyAppBar(),
      body: NestedScrollView(
        controller: scrollController,
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
                  rankListController.obx(
                        (state) {
                      final List<String> keys = state!.data.keys.toList();
                      return SizedBox(
                        height: 50,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            // if (index % 2 != 0) return const SizedBox.shrink();
                            final int key = index * 2;
                            return CustomWideButton(
                              borderWidth: 1,
                              autoSizeText: false,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              buttonText: getButtonTextByFieldName(
                                // rankListController.rankList[index].type,
                                keys[key],
                              ),
                              buttonTextStyle: CustomTexts.bodyLarge,
                              textColor: index == currentIndex
                                  ? context.appColors.onPrimary
                                  : context.appColors.defaultTextColor,
                              buttonColor: index == currentIndex
                                  ? context.appColors.primary
                                  : context.appColors.background,
                              onTap: () => onButtonTap(index),
                            );
                          },
                          separatorBuilder: (_, __) =>
                          const SizedBox(width: 10),
                          itemCount: (state.data.length / 2).ceil(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
        body: rankListController.obx(
              (state) {
            return PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              children: rankListPages(state!.data),
            );
          },
        ),
      ),
    );
  }

  List<Widget> rankListPages(Map<String, List<RankItemModel>> data) {
    final List<Widget> pages = [];
    final List<String> keys = data.keys.toList();
    int length = (data.length / 2).ceil();

    for (int i = 0; i < length; i++) {
      final int key = i * 2;

      pages.add(
        ListView(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomBodyLarge(text: getDescByFieldName(keys[key])),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child:
                      CustomHeadlineSmall(text: getTitleByFieldName(keys[key])),
                ),
                const SizedBox(height: 10),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 16),
                  // itemBuilder: (_, index) =>
                  //     RankingCard(data[keys[key]]![index], index + 1),
                  itemBuilder: (_, index) =>
                      RankingCard(data[keys[key]]![0], 0),
                  // itemCount: data[keys[key]]!.length,
                  itemCount: 20,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomHeadlineSmall(
                      text: getTitleByFieldName(keys[key + 1])),
                ),
                const SizedBox(height: 10),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 16),
                  // itemBuilder: (_, index) =>
                  //     RankingCard(data[keys[key + 1]]![index], index + 1),
                  itemBuilder: (_, index) =>
                      RankingCard(data[keys[key + 1]]![0], 0),
                  // itemCount: data[keys[key + 1]]!.length,
                  itemCount: 20,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ],
        ),
      );
    }

    return pages;
  }

  String getButtonTextByFieldName(String type) {
    switch (type) {
      case 'pointRankerList':
        return localizationManager.rankingPointRankerList;
      case 'walkRankerList':
        return localizationManager.rankingWalkRankerList;
      default:
        return type;
    }
  }

  String getTitleByFieldName(String type) {
    switch (type) {
      case 'pointRankerList':
        return localizationManager.rankingPointRankerList;
      case 'pointCategoryRankerList':
        return localizationManager.rankingPointRankerListStudent;
      case 'walkRankerList':
        return localizationManager.rankingWalkRankerList;
      case 'walkCategoryRankerList':
        return localizationManager.rankingWalkRankerListStudent;
      default:
        return type;
    }
  }

  String getDescByFieldName(String type) {
    switch (type) {
      case 'pointRankerList':
        return localizationManager.rankingRankingDescPoint;
      case 'walkRankerList':
        return localizationManager.rankingRankingDescStepCount;
      default:
        return '';
    }
  }

  void onButtonTap(int index) {
    // log(index.toString());

    setState(() {
      currentIndex = index;
    });
    scrollController.jumpTo(0);
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  void onPageChanged(int index) {
    log(index.toString());
    // log((index % 2).toString());
    scrollController.jumpTo(0);
    setState(() {
      currentIndex = index;
    });
  }
}
