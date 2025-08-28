import 'package:flutter/material.dart';

class GreenCampusPoint extends StatelessWidget {
  const GreenCampusPoint({
    super.key,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/gc_point.png',
      width: width ?? 30,
    );
  }

  final double? width;
}