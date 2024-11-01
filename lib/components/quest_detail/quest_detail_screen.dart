import 'package:BEAT/components/global/widgets/custom_rounded_bordered_container.dart';
import 'package:BEAT/components/global/widgets/custom_scaffold.dart';
import 'package:BEAT/components/global/widgets/texts/custom_body_large.dart';
import 'package:BEAT/components/global/widgets/texts/custom_headline_large.dart';
import 'package:BEAT/components/global/widgets/texts/custom_subtitle_large.dart';
import 'package:BEAT/controller/home/data_controller.dart';
import 'package:BEAT/data/models/data_models.dart';
import 'package:BEAT/data/states/data_state.dart';
import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../managers/navigator/navigator_key_manager.dart';
import '../global/widgets/custom_appbar.dart';
import '../global/widgets/texts/custom_title_large.dart';

class QuestDetailScreen extends StatelessWidget {
  const QuestDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        hasBorder: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: GestureDetector(
            onTap: () => NavigatorKeyManager().pop(),
            child: Icon(
              Icons.arrow_back_ios,
              color: context.appColors.primary,
              size: 24,
            ),
          ),
        ),
        pinned: true,
      ),
      body: BlocBuilder<DataDetailModelController, DataDetailModelState>(
        builder: (context, state) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSubtitleLarge(
                    text: 'Quest',
                    textColor: context.appColors.primary,
                  ),
                  CustomTitleLarge(
                      text: state is DataDetailModelLoadingSuccess
                          ? (state.dataModel! as QuestDetailModel).eventName
                          : ''),
                ],
              ),
              const SizedBox(height: 20),
              CustomRoundedBorderedContainer(
                child: state is DataDetailModelLoadingSuccess
                    ? Image.network(
                        '${dotenv.env['QUEST_IMAGE']!}${(state.dataModel! as QuestDetailModel).eventId}',
                        fit: BoxFit.fill,
                      )
                    : const SizedBox(),
              ),
              const SizedBox(height: 20),
              CustomRoundedBorderedContainer(
                color: context.appColors.background,
                child: state is DataDetailModelLoadingSuccess
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        child: Text((state.dataModel! as QuestDetailModel)
                            .descriptionLong),
                      )
                    : const SizedBox(),
              ),
              const SizedBox(height: 20),
              CustomRoundedBorderedContainer(
                color: context.appColors.background,
                child: state is DataDetailModelLoadingSuccess
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        child: Theme(
                          data: ThemeData(
                            dividerColor: Colors.transparent,
                            dividerTheme: const DividerThemeData(
                              color: Colors.transparent,
                              space: 0,
                              thickness: 0,
                              indent: 0,
                              endIndent: 0,
                            ),
                          ),
                          child: DataTable(
                            headingRowHeight: 0,
                            dividerThickness: 0,
                            columns: const [
                              DataColumn(label: SizedBox()),
                              DataColumn(label: SizedBox())
                            ],
                            rows: [
                              DataRow(
                                cells: [
                                  DataCell(
                                    CustomSubtitleLarge(
                                      text: context.tr('reward'),
                                    ),
                                  ),
                                  DataCell(
                                    CustomSubtitleLarge(
                                      text:
                                          (state.dataModel! as QuestDetailModel)
                                              .neuro
                                              .toString(),
                                    ),
                                  ),
                                ],
                              ),
                              DataRow(
                                cells: [
                                  DataCell(
                                    CustomSubtitleLarge(
                                      text: context.tr('quest_type'),
                                    ),
                                  ),
                                  DataCell(
                                    CustomBodyLarge(
                                        text: (state.dataModel!
                                                as QuestDetailModel)
                                            .eventType),
                                  ),
                                ],
                              ),
                              DataRow(
                                cells: [
                                  DataCell(
                                    CustomSubtitleLarge(
                                      text: context.tr('location'),
                                    ),
                                  ),
                                  DataCell(
                                    CustomBodyLarge(
                                        text: (state.dataModel!
                                                as QuestDetailModel)
                                            .eventLocation),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ))
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
