import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controller/info/controller/info_image_controller.dart';
import '../../../data/states/info_image_state.dart';
import '../../global/widgets/buttons/custom_refresh_button.dart';
import '../../global/widgets/custom_circular_progress_indicator.dart';
import 'info_images_and_smooth_indicator.dart';

class InfoImages extends StatefulWidget {
  const InfoImages({
    super.key,
    required this.activeIndex,
    this.onPageChanged,
  });

  final int activeIndex;
  final Function(int, CarouselPageChangedReason)? onPageChanged;

  @override
  State<InfoImages> createState() => _InfoImagesState();
}

class _InfoImagesState extends State<InfoImages> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InfoImageController, InfoImageState>(
      builder: (context, state) {
        if (state is InfoImageLoaded) {
          return InfoImagesAndSmoothIndicator(
            list: state.imageList,
            activeIndex: widget.activeIndex,
            onPageChanged: widget.onPageChanged,
          );
        } else if (state is InfoImageLoading) {
          return const CustomCircularProgressIndicator();
        } else {
          return CustomRefreshButton();
        }
      },
    );
  }
}