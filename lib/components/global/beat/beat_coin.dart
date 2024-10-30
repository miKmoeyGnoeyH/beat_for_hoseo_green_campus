import 'package:flutter/material.dart';

class BeatCoin extends StatelessWidget {
  const BeatCoin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/beat_coin.png',
      width: 25,
    );
  }
}