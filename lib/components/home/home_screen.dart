import 'package:BEAT/components/home/widgets/home_contents.dart';
import 'package:flutter/material.dart';

import 'widgets/neuroes_in_hand_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: const [
          NeuroesInHandCard(),
          SizedBox(height: 20,),
          HomeContents(),
          SizedBox(height: 20,)
        ],
      ),
    );
  }
}