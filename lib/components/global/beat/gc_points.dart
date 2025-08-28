import 'package:beat_flutter/components/global/beat/gc_point.dart';
import 'package:beat_flutter/components/global/beat/gc_point.dart';
import 'package:flutter/material.dart';

class GreenCampusPoints extends StatelessWidget {
  const GreenCampusPoints({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/gc_points.png',
      width: 80,
    );
  }
}