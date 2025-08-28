
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../global/widgets/custom_rounded_bordered_container.dart';

class InfoImagesCarouselSlider extends StatelessWidget {
  const InfoImagesCarouselSlider({super.key, this.list, this.onPageChanged});

  @override
  Widget build(BuildContext context) {
    return list != null
        ? CarouselSlider.builder(
      itemCount: list!.length,
      itemBuilder: (context, index, _) {
        return CustomRoundedBorderedContainer(
          width: double.infinity,
          height: 200,
          color: context.appColors.disabled,
          child: list![index],
        );
      },
      options: CarouselOptions(
        initialPage: 0,
        viewportFraction: 1,
        enableInfiniteScroll: false,
        onPageChanged: onPageChanged,
      ),
    )
        : const SizedBox();
  }

  final List? list;
  final Function(int, CarouselPageChangedReason)? onPageChanged;
}