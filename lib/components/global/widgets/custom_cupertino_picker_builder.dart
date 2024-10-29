import 'package:flutter/cupertino.dart';

import 'texts/custom_display_medium.dart';

class CustomCupertinoPickerBuilder extends StatelessWidget {
  const CustomCupertinoPickerBuilder({
    super.key,
    required this.items,
    this.onSelectedItemChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker.builder(
      itemExtent: 50,
      childCount: items.length,
      onSelectedItemChanged: onSelectedItemChanged,
      itemBuilder: (context, index) => Center(
        child: CustomDisplayMedium(text: items[index].toString()),
      ),
    );
  }

  final List<dynamic> items;
  final Function(int index)? onSelectedItemChanged;
}