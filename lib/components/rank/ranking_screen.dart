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
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                    height: measureRankPageHeight(
                      context,
                      state.data,
                      currentIndex,
                      cardExtent: 67.w,
                      getDescByFieldName: getDescByFieldName,
                      getTitleByFieldName: getTitleByFieldName,
                    ),
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

  double _textHeight({
    required BuildContext context,
    required String text,
    required TextStyle style,
    required double maxWidth,
  }) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: null, // 줄 제한 없다면 null, 제한 있으면 숫자 지정
    )..layout(maxWidth: maxWidth);
    return tp.size.height;
  }

  /// rankListPages()에서 i번째 페이지(= keys[i*2], keys[i*2+1])의 총 높이 계산
  double measureRankPageHeight(
    BuildContext context,
    Map<String, List<RankItemModel>> data,
    int pageIndex, {
    required double cardExtent, // RankingCard의 고정 높이
    required String Function(String) getDescByFieldName,
    required String Function(String) getTitleByFieldName,
    TextStyle? descStyle,
    TextStyle? titleStyle,
  }) {
    final keys = data.keys.toList();
    final int k = pageIndex * 2;
    final double maxTextWidth =
        MediaQuery.of(context).size.width - 40.w; // 좌우 20.w 패딩

    // 스타일이 명시되지 않았다면 대략적인 기본값(프로젝트 테마에 맞게 바꿔도 됨)
    final dStyle = descStyle ??
        Theme.of(context).textTheme.bodyLarge ??
        const TextStyle(fontSize: 16);
    final tStyle = titleStyle ??
        Theme.of(context).textTheme.headlineSmall ??
        const TextStyle(fontSize: 20, fontWeight: FontWeight.w600);

    // 첫 섹션
    final String key1 = keys[k];
    final String desc1 = getDescByFieldName(key1);
    final String title1 = getTitleByFieldName(key1);
    final int count1 = data[key1]?.length ?? 0;

    final double desc1H = _textHeight(
        context: context, text: desc1, style: dStyle, maxWidth: maxTextWidth);
    final double title1H = _textHeight(
        context: context, text: title1, style: tStyle, maxWidth: maxTextWidth);

    // 두 번째 섹션(짝이 없을 수도 있음)
    final bool hasSecond = k + 1 < keys.length;
    final String? key2 = hasSecond ? keys[k + 1] : null;
    final String title2 = hasSecond ? getTitleByFieldName(key2!) : '';
    final int count2 = hasSecond ? (data[key2!]?.length ?? 0) : 0;
    final double title2H = hasSecond
        ? _textHeight(
            context: context,
            text: title2,
            style: tStyle,
            maxWidth: maxTextWidth)
        : 0;

    // ListView.separated의 구분선 간격(= 16.w)과 리스트 하단 패딩(= 16.w)
    double separatedTotal(int itemCount) {
      if (itemCount <= 0) return 0;
      final gaps = (itemCount - 1).clamp(0, 1 << 30) * 16.w;
      return itemCount * cardExtent + gaps + 16.w; // bottom padding 16.w 포함
    }

    double h = 0;

    // 페이지 구성 요소들의 높이 합(여기 값들은 질문 코드의 SizedBox 및 패딩 간격과 동일)
    h += 10.w; // SizedBox(height: 10.w)
    h += desc1H;
    h += 16.w; // SizedBox(height: 16.w)
    h += title1H;
    h += 16.w; // SizedBox(height: 16.w)
    h += separatedTotal(count1);
    h += 20.w; // SizedBox(height: 20.w)

    if (hasSecond) {
      h += title2H;
      h += 10.w; // SizedBox(height: 10.w)
      h += separatedTotal(count2);
    }

    h += 50.0; // const SizedBox(height: 50)

    return h;
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
    final UserController userController = context.read<UserController>();

    switch (type) {
      case 'pointRankerList':
        return localizationManager.rankingPointRankerList;
      case 'pointCategoryRankerList':
        return userController.state.category == "student"
            ? localizationManager.rankingPointRankerListStudent
            : localizationManager.rankingPointRankerListEmployee;
      case 'walkRankerList':
        return localizationManager.rankingWalkRankerList;
      case 'walkCategoryRankerList':
        return userController.state.category == "student"
            ? localizationManager.rankingWalkRankerListStudent
            : localizationManager.rankingWalkRankerListEmployee;
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
