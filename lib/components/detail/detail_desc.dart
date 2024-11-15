
import 'package:Beat/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../global/widgets/custom_rounded_bordered_container.dart';
import '../global/widgets/texts/custom_body_large.dart';

class DetailDesc extends StatelessWidget {
  const DetailDesc({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return CustomRoundedBorderedContainer(
      borderWidth: 0.5,
      color: context.appColors.background,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: CustomBodyLarge(text: description),
      ),
    );
  }

  final String description;
}
