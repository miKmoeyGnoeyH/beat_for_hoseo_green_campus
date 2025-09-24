import 'package:beat_flutter/components/home/widgets/home_contents.dart';
import 'package:beat_flutter/components/home/widgets/pedometer_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/neuroes_in_hand_card.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final PageController pageController = PageController();
  final List<Widget> widgets = [
    PointsInHandCard(),
    const PedometerCard(),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      // shrinkWrap: true,
      children: [
        Column(
          // shrinkWrap: true,
          // padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 180.w,
              child: PageView(
                controller: pageController,
                children: widgets,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [const HomeContents(), SizedBox(height: 20.w)],
              ),
            )
          ],
        )
      ],
    );
  }
}
