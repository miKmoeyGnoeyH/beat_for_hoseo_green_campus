import 'dart:developer';

import 'package:beat_flutter/components/global/widgets/buttons/custom_refresh_button.dart';
import 'package:beat_flutter/components/global/widgets/buttons/custom_wide_button.dart';
import 'package:beat_flutter/components/global/widgets/custom_circular_progress_indicator.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_headline_small.dart';
import 'package:beat_flutter/components/rank/widgets/ranking_card.dart';
import 'package:beat_flutter/controller/rank/rank_controller_test.dart';
import 'package:beat_flutter/data/models/data_models.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/theme/texts/custom_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
    return Scaffold(
      backgroundColor: context.appColors.surface,
      appBar: AppBar(
        foregroundColor: context.appColors.primary,
        backgroundColor: context.appColors.surface,
        surfaceTintColor: context.appColors.surface,
        shape: Border(
          bottom: BorderSide(
              color: context.appColors.borderColor.withValues(alpha: 0.2),
              width: 0.5),
        ),
      ),
      body: SafeArea(
        child: rankListController.obx(
          (state) {
            final List<String> keys = state!.data.keys.toList();

            return RefreshIndicator(
              color: context.appColors.primary,
              onRefresh: () {
                onButtonTap(0);
                return rankListController.fetchRankList();
              },
              child: ListView(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 16.w, bottom: 10.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 20.w),
                              child: CustomDisplayMedium(
                                text: localizationManager.rankingRanking,
                                textColor: context.appColors.defaultTextColor,
                              ),
                            ),
                            SizedBox(height: 16.w),
                            SizedBox(
                              height: 50.w,
                              child: ListView.separated(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  // if (index % 2 != 0) return const SizedBox.shrink();
                                  final int key = index * 2;
                                  return CustomWideButton(
                                    width: 130.w,
                                    borderWidth: 0.5,
                                    autoSizeText: true,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                      vertical: 10.w,
                                    ),
                                    buttonText: getButtonTextByFieldName(
                                      // rankListController.rankList[index].type,
                                      keys[key],
                                    ),
                                    buttonTextStyle: CustomLargeTexts.bodyLarge,
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
                                    SizedBox(width: 10.w),
                                itemCount: (state.data.length / 2).ceil(),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: getPageHeight(state.data),
                    child: PageView(
                      controller: pageController,
                      onPageChanged: onPageChanged,
                      children: rankListPages(state.data),
                    ),
                  ),
                ],
              ),
            );
          },
          onLoading: const CustomCircularProgressIndicator(),
          onError: (_) {
            return CustomRefreshButton(
              onTap: () => rankListController.fetchRankList(),
            );
          },
        ),
      ),
    );
  }

  double getPageHeight(Map<String, List<RankItemModel>> data) {
    final List<String> keys = data.keys.toList();

    double appBarHeight = kToolbarHeight;
    double textsHeight = 100.w;
    double rankCardHeight = 65.w;
    double paddingHeight = 16.w;
    double extraSpacingHeight = 50.w;

    final double spacingHeight = (40.w +
        (((data[keys[currentIndex]]!.length - 1).toDouble() +
                (data[keys[currentIndex + 1]]!.length - 1).toDouble()) *
            10.w));
    // final double spacingHeight = (40 + ((19 + 19) * 10));
    final double contentHeight = (data[keys[currentIndex]]!.length.toDouble() +
            data[keys[currentIndex + 1]]!.length.toDouble()) *
        rankCardHeight;
    // final double contentHeight = (20 + 20) * rankCardHeight;

    return (appBarHeight +
        textsHeight +
        paddingHeight +
        extraSpacingHeight +
        spacingHeight +
        contentHeight);
  }

  List<Widget> rankListPages(Map<String, List<RankItemModel>> data) {
    final List<Widget> pages = [];
    final List<String> keys = data.keys.toList();
    int length = (data.length / 2).ceil();

    for (int i = 0; i < length; i++) {
      final int key = i * 2;

      pages.add(
        ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.w),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: CustomBodyLarge(text: getDescByFieldName(keys[key])),
                ),
                SizedBox(height: 16.w),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child:
                      CustomHeadlineSmall(text: getTitleByFieldName(keys[key])),
                ),
                SizedBox(height: 16.w),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding:
                      EdgeInsets.only(left: 20.w, right: 20.w, bottom: 16.w),
                  itemBuilder: (_, index) =>
                      RankingCard(data[keys[key]]![index], index + 1),
                  // itemBuilder: (_, index) =>
                  //     RankingCard(data[keys[key]]![0], 0),
                  itemCount: data[keys[key]]!.length,
                  // itemCount: 20,
                  separatorBuilder: (_, __) => SizedBox(height: 16.w),
                ),
                SizedBox(height: 20.w),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: CustomHeadlineSmall(
                      text: getTitleByFieldName(keys[key + 1])),
                ),
                SizedBox(height: 10.w),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding:
                      EdgeInsets.only(left: 20.w, right: 20.w, bottom: 16.w),
                  itemBuilder: (_, index) =>
                      RankingCard(data[keys[key + 1]]![index], index + 1),
                  // itemBuilder: (_, index) =>
                  //     RankingCard(data[keys[key + 1]]![0], 0),
                  itemCount: data[keys[key + 1]]!.length,
                  // itemCount: 20,
                  separatorBuilder: (_, __) => SizedBox(height: 16.w),
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
