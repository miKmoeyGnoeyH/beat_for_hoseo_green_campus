import 'package:flutter/material.dart';

class BeatCoin extends StatelessWidget {
  const BeatCoin({
    super.key,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/beat_coin.png',
      width: width ?? 25,
    );
  }

  final double? width;
}