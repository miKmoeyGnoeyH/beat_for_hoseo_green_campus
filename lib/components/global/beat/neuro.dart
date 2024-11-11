import 'package:flutter/material.dart';

class Neuro extends StatelessWidget {
  const Neuro({
    super.key,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/neuro.png',
      width: width ?? 25,
    );
  }

  final double? width;
}