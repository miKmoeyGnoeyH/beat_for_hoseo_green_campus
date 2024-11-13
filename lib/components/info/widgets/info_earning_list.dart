import 'package:flutter/material.dart';

import '../../../data/models/data_models.dart';
import 'info_earning_list_contents.dart';

class InfoEarningList extends StatelessWidget {
  const InfoEarningList(
      this.earnings, {
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: earnings != null ? earnings!.length : 0,
      separatorBuilder: (context, index) => const SizedBox(
        height: 16,
      ),
      itemBuilder: (context, index) {
        return InfoEarningListContents(earnings![index]);
      },
    );
  }

  final List<InfoModel>? earnings;
}