import 'package:beat_flutter/components/home/widgets/home_contents.dart';
import 'package:beat_flutter/components/home/widgets/pedometer_card_stack.dart';
import 'package:beat_flutter/components/home/widgets/permission_required_card.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/permission/permission_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'widgets/neuroes_in_hand_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController pageController = PageController();

  final List<Widget> widgets = [
    const PedometerCardStack(),
    PointsInHandCard(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      // shrinkWrap: true,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.w),
          child: Column(
            // shrinkWrap: true,
            // padding: EdgeInsets.zero,
            children: [
              // const PermissionRequiredCard(),
              // SizedBox(height: 16.w),
              SizedBox(
                width: double.infinity,
                height: 138.w,
                child: PageView(
                  controller: pageController,
                  children: widgets,
                ),
              ),
              SizedBox(height: 10.w),
              SmoothPageIndicator(
                controller: pageController,
                count: widgets.length,
                effect: ColorTransitionEffect(
                  dotWidth: 10.w,
                  dotHeight: 10.w,
                  dotColor: context.appColors.disabled,
                  activeDotColor: context.appColors.primary,
                ),
              ),
              SizedBox(height: 16.w),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [const HomeContents(), SizedBox(height: 20.w)],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
