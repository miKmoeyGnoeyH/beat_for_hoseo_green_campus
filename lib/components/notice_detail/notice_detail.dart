import 'package:beat_flutter/components/detail/detail_desc.dart';
import 'package:beat_flutter/components/detail/detail_label_and_title.dart';
import 'package:beat_flutter/components/global/widgets/appbars/custom_empty_appbar.dart';
import 'package:beat_flutter/components/global/widgets/custom_rounded_bordered_container.dart';
import 'package:beat_flutter/components/global/widgets/custom_scaffold.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_body_large.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_subtitle_large.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_title_large.dart';
import 'package:beat_flutter/data/models/data_models.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoticeDetail extends StatelessWidget {
  NoticeDetail({super.key, required this.notificationModel});

  final LocalizationManager localizationManager = LocalizationManager();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        bottom: true,
        appBar: const CustomEmptyAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailLabelAndTItle(
                  labelText: localizationManager.noticeLabel,
                  title: notificationModel.title,
                ),
                const SizedBox(height: 10),
                CustomSubtitleLarge(
                  text: DateFormat("yyyy-MM-dd HH:mm:ss")
                      .format(notificationModel.createdAt),
                  textColor: context.appColors.disabled,
                ),
                const SizedBox(height: 20),
                CustomRoundedBorderedContainer(
                  width: double.infinity,
                  borderWidth: 0.5,
                  color: context.appColors.background,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: CustomBodyLarge(text: notificationModel.body),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }

  final NotificationModel notificationModel;
}
