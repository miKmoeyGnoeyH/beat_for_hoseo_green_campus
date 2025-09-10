import 'package:beat_flutter/components/global/widgets/texts/custom_body_large.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_title_large.dart';
import 'package:beat_flutter/components/quest_detail/widgets/quest_detail_additional_info_card.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    children: [
                      DetailLabelAndTItle(
                        labelText: 'Quest',
                        title: (state.dataModel! as QuestDetailModel).eventName,
                      ),
                      const SizedBox(height: 20),
                      (state.dataModel! as QuestDetailModel).hasImage
                          ? DetailImage(
                              imageUrl:
                                  '${DotEnvManager().questImage}${(state.dataModel! as QuestDetailModel).eventId}')
                          : SizedBox(
                              height: 150,
                              child: Center(
                                child: CustomBodyLarge(
                                  text: localizationManager.qdNoImage,
                                  textColor: context.appColors.disabled,
                                ),
                              ),
                            ),
                      const SizedBox(height: 20),
                      DetailDesc(
                        description: (state.dataModel! as QuestDetailModel)
                            .descriptionLong,
                      ),
                      const SizedBox(height: 20),
                      QuestDetailTable(
                        child: QuestDetailTableContents(
                          state.dataModel! as QuestDetailModel,
                        ),
                      ),
                      const SizedBox(height: 20),
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
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
                                      return const SizedBox(height: 20);
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
