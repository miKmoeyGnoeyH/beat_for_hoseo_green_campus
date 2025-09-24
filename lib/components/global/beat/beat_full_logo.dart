import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class BeatFullLogo extends StatelessWidget {
  const BeatFullLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 75.w),
        child: SvgPicture.asset("assets/svg/beat_hgc_logo_primary.svg"),
        // Image.asset(
        //   'assets/images/beat_full_logo.png',
        //   width: context.width * 0.3,
        //   height: context.height * 0.15,
        // ),
      ),
    );
  }
}