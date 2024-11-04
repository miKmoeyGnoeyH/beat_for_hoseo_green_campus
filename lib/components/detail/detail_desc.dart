import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../global/widgets/custom_rounded_bordered_container.dart';

class DetailDesc extends StatelessWidget {
  const DetailDesc({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return CustomRoundedBorderedContainer(
      color: context.appColors.background,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Text(description),
      ),
    );
  }

  final String description;
}
