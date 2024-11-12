import 'package:flutter/material.dart';

import '../../../data/models/data_models.dart';
import 'info_spending_list_contents.dart';

class InfoSpendingList extends StatelessWidget {
  const InfoSpendingList(
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
        height: 10,
      ),
      itemBuilder: (context, index) {
        return InfoSpendingListContents(earnings![index]);
      },
    );
  }

  final List<InfoModel>? earnings;
}