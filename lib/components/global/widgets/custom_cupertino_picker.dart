import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_cupertino_picker_builder.dart';

class CustomCupertinoPicker extends StatelessWidget {
  const CustomCupertinoPicker({
    super.key,
    required this.items,
    this.onSelectedItemChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: CustomCupertinoPickerBuilder(
          items: items,
          onSelectedItemChanged: onSelectedItemChanged,
        ),
      ),
    );
  }

  final List<dynamic> items;
  final Function(int index)? onSelectedItemChanged;
}