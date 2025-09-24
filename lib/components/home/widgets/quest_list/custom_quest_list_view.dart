import 'package:beat_flutter/components/global/widgets/texts/custom_body_large.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_headline_small.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_title_medium.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/models/data_models.dart';
import 'quest_card.dart';

class CustomQuestListView extends StatefulWidget {
  const CustomQuestListView({
    super.key,
    required this.list,
    this.child,
  });

  @override
  State<CustomQuestListView> createState() => _CustomQuestListViewState();

  final List<DataModel> list;
  final Widget? child;
}

class _CustomQuestListViewState extends State<CustomQuestListView> {
  @override
  void initState() {
    // qrQuestsLength = qrQuests.length;
    // walkQuestsLength = walkQuests.length;
    // walkDailyQuestsLength = walkQuests
    //     .where((e) =>
    //         (e as QuestWalkModel).eventPeriodType == EventPeriodType.daily)
    //     .length;
    // walkWeeklyQuestsLength = walkQuests
    //     .where((e) =>
    //         (e as QuestWalkModel).eventPeriodType == EventPeriodType.weekly)
    //     .length;
    // walkMonthlyQuestsLength = walkQuests
    //     .where((e) =>
    //         (e as QuestWalkModel).eventPeriodType == EventPeriodType.monthly)
    //     .length;
    super.initState();
  }

  final LocalizationManager localizationManager = LocalizationManager();

  @override
  Widget build(BuildContext context) {
    qrQuests = widget.list
        .where((e) => (e as QuestModel).eventType == EventType.qr)
        .toList();

    walkQuests = widget.list
        .where((e) => (e as QuestModel).eventType == EventType.walk)
        .toList();

    qrQuestsLength = qrQuests.length;
    walkQuestsLength = walkQuests.length;
    walkDailyQuestsLength = walkQuests
        .where((e) =>
            (e as QuestWalkModel).eventPeriodType == EventPeriodType.daily)
        .length;
    walkWeeklyQuestsLength = walkQuests
        .where((e) =>
            (e as QuestWalkModel).eventPeriodType == EventPeriodType.weekly)
        .length;
    walkMonthlyQuestsLength = walkQuests
        .where((e) =>
            (e as QuestWalkModel).eventPeriodType == EventPeriodType.monthly)
        .length;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.w),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child:
                    CustomHeadlineSmall(text: localizationManager.homeQRQuest),
              ),
              qrQuestsLength != 0
                  ? ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.list
                          .where((e) =>
                              (e as QuestModel).eventType == EventType.qr)
                          .length,
                      padding: EdgeInsets.symmetric(vertical: 20.w),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 24.w),
                      itemBuilder: (context, index) {
                        final List<DataModel> qrQuests = widget.list
                            .where((e) =>
                                (e as QuestModel).eventType == EventType.qr)
                            .toList();

                        return QuestCard(
                          index: index,
                          questModel: qrQuests[index] as QuestModel,
                        );
                      },
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.w),
                      child: SizedBox(
                        height: 30.w,
                        width: double.infinity,
                        child: CustomBodyLarge(
                          text: localizationManager.homeNoQuests,
                          textColor: context.appColors.borderColor,
                        ),
                      ),
                    ),
            ],
          ),
          SizedBox(height: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: CustomHeadlineSmall(
                    text: localizationManager.homeWalkQuest),
              ),
              walkQuestsLength != 0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.w),
                        walkDailyQuestsLength != 0
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w),
                                    child: CustomTitleMedium(
                                      text: localizationManager.homeDaily,
                                    ),
                                  ),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: walkQuests
                                        .where((e) =>
                                            (e as QuestWalkModel)
                                                .eventPeriodType ==
                                            EventPeriodType.daily)
                                        .length,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20.w),
                                    separatorBuilder: (context, index) =>
                                        SizedBox(height: 24.w),
                                    itemBuilder: (context, index) {
                                      final List<DataModel> walkDailyQuests =
                                          walkQuests
                                              .where((e) =>
                                                  (e as QuestWalkModel)
                                                      .eventPeriodType ==
                                                  EventPeriodType.daily)
                                              .toList();

                                      return QuestCard(
                                        index: index,
                                        questModel: walkDailyQuests[index]
                                            as QuestModel,
                                      );
                                    },
                                  )
                                ],
                              )
                            : const SizedBox.shrink(),
                        walkWeeklyQuestsLength != 0
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // const SizedBox(height: 10),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w),
                                    child: CustomTitleMedium(
                                      text: localizationManager.homeWeekly,
                                    ),
                                  ),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: walkQuests
                                        .where((e) =>
                                            (e as QuestWalkModel)
                                                .eventPeriodType ==
                                            EventPeriodType.weekly)
                                        .length,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20.w),
                                    separatorBuilder: (context, index) =>
                                        SizedBox(height: 24.w),
                                    itemBuilder: (context, index) {
                                      final List<DataModel> walkWeeklyQuests =
                                          walkQuests
                                              .where((e) =>
                                                  (e as QuestWalkModel)
                                                      .eventPeriodType ==
                                                  EventPeriodType.weekly)
                                              .toList();

                                      return QuestCard(
                                        index: index,
                                        questModel: walkWeeklyQuests[index]
                                            as QuestModel,
                                      );
                                    },
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                        walkMonthlyQuestsLength != 0
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // const SizedBox(height: 10),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w),
                                    child: CustomTitleMedium(
                                      text: localizationManager.homeMonthly,
                                    ),
                                  ),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: walkQuests
                                        .where((e) =>
                                            (e as QuestWalkModel)
                                                .eventPeriodType ==
                                            EventPeriodType.monthly)
                                        .length,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20.w),
                                    separatorBuilder: (context, index) =>
                                        SizedBox(height: 24.w),
                                    itemBuilder: (context, index) {
                                      final List<DataModel> walkMonthlyQuests =
                                          walkQuests
                                              .where((e) =>
                                                  (e as QuestWalkModel)
                                                      .eventPeriodType ==
                                                  EventPeriodType.monthly)
                                              .toList();

                                      return QuestCard(
                                        index: index,
                                        questModel: walkMonthlyQuests[index]
                                            as QuestModel,
                                      );
                                    },
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ],
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.w),
                      child: SizedBox(
                        height: 30.w,
                        width: double.infinity,
                        child: CustomBodyLarge(
                          text: localizationManager.homeNoQuests,
                          textColor: context.appColors.borderColor,
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  List<DataModel> qrQuests = [];

  List<DataModel> walkQuests = [];

  int qrQuestsLength = 0;

  int walkQuestsLength = 0;

  int walkDailyQuestsLength = 0;

  int walkWeeklyQuestsLength = 0;

  int walkMonthlyQuestsLength = 0;
}
