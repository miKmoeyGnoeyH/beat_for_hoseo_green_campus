import 'package:flutter/material.dart';

import 'org_col_dep_label.dart';

class OrgColDepIndicator extends StatelessWidget {
  const OrgColDepIndicator({
    super.key,
    this.colText,
    this.orgText,
    this.depText,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          OrgColDepLabel(text: orgText),
          const SizedBox(width: 15),
          colText != '' ? OrgColDepLabel(text: colText) : const SizedBox(),
          const SizedBox(width: 15),
          OrgColDepLabel(text: depText),
        ],
      ),
    );
  }

  final String? orgText;
  final String? colText;
  final String? depText;
}
