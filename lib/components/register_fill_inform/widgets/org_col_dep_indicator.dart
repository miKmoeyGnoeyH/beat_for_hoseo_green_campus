import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          SizedBox(width: 15.w),
          colText != '' ? OrgColDepLabel(text: colText) : const SizedBox(),
          SizedBox(width: 15.w),
          OrgColDepLabel(text: depText),
        ],
      ),
    );
  }

  final String? orgText;
  final String? colText;
  final String? depText;
}
