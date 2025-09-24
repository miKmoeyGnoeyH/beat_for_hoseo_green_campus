import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GreenCampusPoints extends StatelessWidget {
  const GreenCampusPoints({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/gc_points.png',
      width: 90.w,
    );
  }
}