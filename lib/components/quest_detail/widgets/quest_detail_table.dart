import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../../global/widgets/custom_rounded_bordered_container.dart';

class QuestDetailTable extends StatelessWidget {
  const QuestDetailTable({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomRoundedBorderedContainer(
      color: context.appColors.background,
      child: child,
    );
  }

  final Widget child;
}