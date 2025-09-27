import 'dart:developer';

import 'package:beat_flutter/components/global/widgets/buttons/custom_refresh_button.dart';
import 'package:beat_flutter/components/global/widgets/buttons/custom_text_button.dart';
import 'package:beat_flutter/components/global/widgets/buttons/custom_text_button_wrap.dart';
import 'package:beat_flutter/components/global/widgets/custom_circular_progress_indicator.dart';
import 'package:beat_flutter/components/global/widgets/custom_rounded_bordered_container.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_body_large.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_display_medium.dart';
import 'package:beat_flutter/components/my_page/widgets/step_count_statistics_chart.dart';
import 'package:beat_flutter/controller/my_page/my_page_controller.dart';
import 'package:beat_flutter/controller/pedometer/pedometer_controller.dart';
import 'package:beat_flutter/controller/user_controller.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/navigator/navigator_key_manager.dart';
import 'package:beat_flutter/managers/navigator/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pedometer/pedometer.dart';

class MyPage extends StatefulWidget {
  MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final MyPageController myPageController = Get.find<MyPageController>();
  final PedometerController pedometerController =
      Get.find<PedometerController>();

  final LocalizationManager localizationManager = LocalizationManager();

  @override
  void initState() {
    final String authorization =
        context.read<UserController>().state.authorization;
    myPageController.getMyPageData(authorization);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserController userController = context.read<UserController>();

    // log(userController.state.category);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomDisplayMedium(
                        text: localizationManager.mpAppbarTitle),
                    SizedBox(width: 10.w),
                    CustomTextButtonWrap(
                      text: localizationManager.mpChangePassword,
                      textColor: context.appColors.onBackground,
                      buttonColor: context.appColors.background,
                      borderColor: context.appColors.borderColor,
                      borderWidth: 0.3,
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.w),
                      onTap: onForgotPasswordTap,
                      // padding: ,
                    ),
                  ],
                ),
                SizedBox(height: 16.w),
                CustomRoundedBorderedContainer(
                  width: double.infinity,
                  borderWidth: 0.5.w,
                  color: context.appColors.background,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
                    child: Table(
                      children: [
                        buildMyPageTableRow(
                          label: localizationManager.mpCategory,
                          content: getCategory(userController.state.category),
                        ),
                        buildMyPageTableRowSpacing(),
                        buildMyPageTableRow(
                          label: localizationManager.mpName,
                          content: userController.state.name,
                        ),
                        buildMyPageTableRowSpacing(),
                        buildMyPageTableRow(
                          label: getDepartmentOrAffiliation(
                              userController.state.category),
                          content: userController.state.department,
                        ),
                        buildMyPageTableRowSpacing(),
                        buildMyPageTableRow(
                          label: localizationManager.mpEmail,
                          content: userController.state.email,
                        ),
                        buildMyPageTableRowSpacing(),
                        buildMyPageTableRow(
                          label: localizationManager.mpNickname,
                          content: userController.state.nickname,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.w),
                myPageController.obx(
                  (state) {
                    return Column(
                      children: [
                        Obx(() {
                          return StepCountStatisticsChart(
                            barItems: [
                              BarItem(
                                label: localizationManager.mpTodayWalkCount,
                                value: pedometerController.todayWalkCount,
                              ),
                              BarItem(
                                label: localizationManager.mpLastWeekMean,
                                value: myPageController
                                    .state.walkMeanHistoryModel.weeklyWalkCount,
                              ),
                              BarItem(
                                label: localizationManager.mpLastMonthMean,
                                value: myPageController.state.walkMeanHistoryModel.monthlyWalkCount,
                                // value: 1000,
                              ),
                            ],
                          );
                        }),
                        SizedBox(height: 16.w),
                        if (Localizations.localeOf(context).languageCode ==
                            "ko")
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: CustomRoundedBorderedContainer(
                                  width: double.infinity,
                                  borderWidth: 0.5.w,
                                  color: context.appColors.background,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 16.w),
                                    child: Table(
                                      children: [
                                        buildMyPageTableRow(
                                          label: localizationManager
                                              .mpMyTotalRanking,
                                          content: myPageController
                                              .state.myRankModel.pointRank
                                              .toString(),
                                        ),
                                        buildMyPageTableRowSpacing(),
                                        buildMyPageTableRow(
                                          label: localizationManager
                                              .mpTotalWalkCount,
                                          content: myPageController
                                              .state.myRankModel.walk
                                              .toString(),
                                        ),
                                        buildMyPageTableRowSpacing(),
                                        buildMyPageTableRow(
                                          label:
                                              localizationManager.mpTotalPoint,
                                          content: myPageController
                                              .state.myRankModel.point
                                              .toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Flexible(
                                flex: 1,
                                child: CustomRoundedBorderedContainer(
                                  width: double.infinity,
                                  borderWidth: 0.5.w,
                                  color: context.appColors.background,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 16.w),
                                    child: Table(
                                      children: [
                                        buildMyPageTableRow(
                                          label: localizationManager
                                              .mpCategoryRanking(getCategory(
                                                  userController
                                                      .state.category)),
                                          content: myPageController
                                              .state.myRankModel.pointRank
                                              .toString(),
                                        ),
                                        buildMyPageTableRowSpacing(),
                                        buildMyPageTableRow(
                                          label: localizationManager
                                              .mpTotalWalkCount,
                                          content: myPageController
                                              .state.myRankModel.walk
                                              .toString(),
                                        ),
                                        buildMyPageTableRowSpacing(),
                                        buildMyPageTableRow(
                                          label:
                                              localizationManager.mpTotalPoint,
                                          content: myPageController
                                              .state.myRankModel.point
                                              .toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        else
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomRoundedBorderedContainer(
                                width: double.infinity,
                                borderWidth: 0.5.w,
                                color: context.appColors.background,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 16.w),
                                  child: Table(
                                    children: [
                                      buildMyPageTableRow(
                                        label: localizationManager
                                            .mpMyTotalRanking,
                                        content: myPageController
                                            .state.myRankModel.pointRank
                                            .toString(),
                                      ),
                                      buildMyPageTableRowSpacing(),
                                      buildMyPageTableRow(
                                        label: localizationManager
                                            .mpTotalWalkCount,
                                        content: myPageController
                                            .state.myRankModel.walk
                                            .toString(),
                                      ),
                                      buildMyPageTableRowSpacing(),
                                      buildMyPageTableRow(
                                        label: localizationManager.mpTotalPoint,
                                        content: myPageController
                                            .state.myRankModel.point
                                            .toString(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.w),
                              CustomRoundedBorderedContainer(
                                width: double.infinity,
                                borderWidth: 0.5.w,
                                color: context.appColors.background,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 16.w),
                                  child: Table(
                                    children: [
                                      buildMyPageTableRow(
                                        label: localizationManager
                                            .mpCategoryRanking(getCategory(
                                                userController.state.category)),
                                        content: myPageController
                                            .state.myRankModel.pointRank
                                            .toString(),
                                      ),
                                      buildMyPageTableRowSpacing(),
                                      buildMyPageTableRow(
                                        label: localizationManager
                                            .mpTotalWalkCount,
                                        content: myPageController
                                            .state.myRankModel.walk
                                            .toString(),
                                      ),
                                      buildMyPageTableRowSpacing(),
                                      buildMyPageTableRow(
                                        label: localizationManager.mpTotalPoint,
                                        content: myPageController
                                            .state.myRankModel.point
                                            .toString(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                      ],
                    );
                  },
                  onLoading: SizedBox(
                    height: 250.w,
                    child: const CustomCircularProgressIndicator(),
                  ),
                  onError: (state) {
                    return SizedBox(
                      height: 250.w,
                      child: CustomRefreshButton(
                        onTap: () => myPageController
                            .getMyPageData(userController.state.authorization),
                      ),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onForgotPasswordTap() {
    // log("forgot password");
    NavigatorKeyManager().pushNamed(RouteNames.resetPassword);
  }

  String getDepartmentOrAffiliation(String category) => switch (category) {
        "student" => localizationManager.mpDepartment,
        "employee" => localizationManager.mpAffiliation,
        _ => localizationManager.mpAffiliation,
      };

  String getCategory(String category) => switch (category) {
        "student" => localizationManager.mpStudent,
        "employee" => localizationManager.mpEmployee,
        _ => localizationManager.mpOthers,
      };

  String getIDLabel(String category) => switch (category) {
        "student" => localizationManager.mpStudentID,
        "employee" => localizationManager.mpEmployeeID,
        _ => localizationManager.mpID,
      };
}

TableRow buildMyPageTableRow(
    {required String? label, required String? content}) {
  return TableRow(
    children: [
      TableCell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomBodyLarge(text: label),
            CustomBodyLarge(text: content),
          ],
        ),
      ),
    ],
  );
}

TableRow buildMyPageTableRowSpacing() {
  return TableRow(
    children: [
      TableCell(
        child: SizedBox(height: 10.w),
      ),
    ],
  );
}
