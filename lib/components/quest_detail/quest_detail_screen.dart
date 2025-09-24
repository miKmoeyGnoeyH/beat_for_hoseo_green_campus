import 'package:beat_flutter/components/global/widgets/texts/custom_body_large.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_title_large.dart';
import 'package:beat_flutter/components/quest_detail/widgets/quest_detail_additional_info_card.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controller/home/controllers/data_controller.dart';
import '../../controller/home/events/data_events.dart';
import '../../data/models/data_models.dart';
import '../../data/states/data_state.dart';
import '../detail/detail_desc.dart';
import '../detail/detail_image.dart';
import '../detail/detail_label_and_title.dart';
import '../global/widgets/appbars/custom_empty_appbar.dart';
import '../global/widgets/buttons/custom_refresh_button.dart';
import '../global/widgets/custom_circular_progress_indicator.dart';
import '../global/widgets/custom_scaffold.dart';
import 'widgets/quest_detail_table.dart';
import 'widgets/quest_detail_table_contents.dart';

class QuestDetailScreen extends StatefulWidget {
  const QuestDetailScreen({super.key});

  @override
  State<QuestDetailScreen> createState() => _QuestDetailScreenState();
}

class _QuestDetailScreenState extends State<QuestDetailScreen> {
  final LocalizationManager localizationManager = LocalizationManager();

  @override
  Widget build(BuildContext context) {
    final DataDetailModelController dataDetailModelController =
        context.read<DataDetailModelController>();

    return CustomScaffold(
      bottom: true,
      appBar: const CustomEmptyAppBar(),
      body: BlocBuilder<DataDetailModelController, DataDetailModelState>(
        builder: (context, state) => state is DataDetailModelLoadingSuccess
            ? SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
                  child: Column(
                    children: [
                      DetailLabelAndTItle(
                        labelText: 'Quest',
                        title: (state.dataModel! as QuestDetailModel).eventName,
                      ),
                      SizedBox(height: 20.w),
                      (state.dataModel! as QuestDetailModel).hasImage
                          ? DetailImage(
                              imageUrl:
                                  '${DotEnvManager().questImage}${(state.dataModel! as QuestDetailModel).eventId}')
                          : SizedBox(
                              height: 150.w,
                              child: Center(
                                child: CustomBodyLarge(
                                  text: localizationManager.qdNoImage,
                                  textColor: context.appColors.disabled,
                                ),
                              ),
                            ),
                      SizedBox(height: 20.w),
                      DetailDesc(
                        description: (state.dataModel! as QuestDetailModel)
                            .descriptionLong,
                      ),
                      SizedBox(height: 20.w),
                      QuestDetailTable(
                        child: QuestDetailTableContents(
                          state.dataModel! as QuestDetailModel,
                        ),
                      ),
                      SizedBox(height: 20.w),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (state.dataModel! as QuestDetailModel).eventType ==
                                    EventType.qr
                                ? CustomTitleLarge(
                                    text: localizationManager
                                        .qdAdditionalInformation,
                                  )
                                : const SizedBox.shrink(),
                            (state.dataModel! as QuestDetailModel).eventType ==
                                    EventType.qr
                                ? ListView.separated(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20.w),
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return QuestDetailAdditionalInfoCard(
                                        qrMissionDTO: ((state.dataModel!
                                                    as QuestDetailModel)
                                                .eventLongDTO as EventQRLongDTO)
                                            .qrMissionLongDTO
                                            .qrMissionDTOList[index],
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return SizedBox(height: 20.w);
                                    },
                                    itemCount:
                                        ((state.dataModel! as QuestDetailModel)
                                                .eventLongDTO as EventQRLongDTO)
                                            .qrMissionLongDTO
                                            .qrMissionDTOList
                                            .length,
                                  )
                                : const SizedBox.shrink()
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            : state is DataDetailModelLoadingError
                ? CustomRefreshButton(
                    onTap: () => dataDetailModelController.add(
                      DataDetailRequest(),
                    ),
                  )
                : const CustomCircularProgressIndicator(),
      ),
    );
  }
}
