import 'package:beat_flutter/components/home/widgets/home_contents.dart';
import 'package:beat_flutter/components/home/widgets/pedometer_card.dart';
import 'package:flutter/material.dart';

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
      shrinkWrap: true,
      children: [
        Column(
          // shrinkWrap: true,
          // padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 160,
              child: PageView(
                controller: pageController,
                children: widgets,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [HomeContents(), SizedBox(height: 20)],
              ),
            )
          ],
        )
      ],
    );
  }
}
