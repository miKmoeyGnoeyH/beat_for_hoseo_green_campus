
import 'package:beat_flutter/controller/user_controller.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/data_models.dart';
import '../../global/widgets/texts/custom_title_large.dart';

class RankNeuro extends StatelessWidget {
  const RankNeuro({
    super.key,
    required this.ranking,
  });

  final RankItemModel ranking;

  @override
  Widget build(BuildContext context) {
    final UserController userController = context.read<UserController>();

    return Row(
      children: [
        // const Neuro(),
        // const SizedBox(width: 8),
        CustomTitleLarge(
          text: NumberFormat("###,###,###,###").format(ranking.num),
          textColor: context.appColors.primary,
        ),
      ],
    );
  }
}
