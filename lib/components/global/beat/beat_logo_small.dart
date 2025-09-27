import 'package:flutter/material.dart';

class BeatLogoSmall extends StatelessWidget {
  const BeatLogoSmall({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/beat_icon.png',
      // width: 24.w,
      // height: 24.w,
      width: 24,
      height: 24,
      fit: BoxFit.cover,
    );
  }
}