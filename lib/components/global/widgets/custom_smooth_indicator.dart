import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomSmoothIndicator extends StatelessWidget {
  const CustomSmoothIndicator({
    super.key,
    required this.activeIndex,
    this.list,
  });

  final int activeIndex;
  final List? list;

  @override
  Widget build(BuildContext context) {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: list != null ? list!.length : 0,
      effect: ColorTransitionEffect(
        activeDotColor: context.appColors.primary,
        dotColor: context.appColors.disabled,
        dotWidth: 8,
        dotHeight: 8,
      ),
    );
  }
}