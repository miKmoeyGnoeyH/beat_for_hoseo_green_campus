import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../controller/home/data_controller.dart';
import '../../../../controller/home/data_events.dart';
import 'custom_wide_button.dart';

class CustomRetryButton extends StatelessWidget {
  const CustomRetryButton({
    super.key,
    required this.dataDetailModelController,
  });

  final DataDetailModelController dataDetailModelController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(context.tr('connection_error')),
          CustomWideButton(
            onTap: () {
              dataDetailModelController.add(DataDetailRequest());
            },
            buttonText: context.tr('retry'),
            buttonColor: context.appColors.primary,
          ),
        ],
      ),
    );
  }
}