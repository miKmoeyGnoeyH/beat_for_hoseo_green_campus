import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../global/widgets/custom_smooth_indicator.dart';
import 'info_images_carousel_slider.dart';

class InfoImagesAndSmoothIndicator extends StatelessWidget {
  const InfoImagesAndSmoothIndicator({
    super.key,
    required this.activeIndex,
    this.list,
    this.onPageChanged,
  });

  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InfoImagesCarouselSlider(
          list: list,
          onPageChanged: onPageChanged,
        ),
        const SizedBox(height: 10),
        CustomSmoothIndicator(
          activeIndex: activeIndex,
          list: list,
        ),
      ],
    );
  }

  final List? list;
  final Function(int, CarouselPageChangedReason)? onPageChanged;
}