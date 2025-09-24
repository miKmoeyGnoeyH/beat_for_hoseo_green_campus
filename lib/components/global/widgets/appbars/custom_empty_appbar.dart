import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../managers/navigator/navigator_key_manager.dart';
import 'custom_appbar.dart';

class CustomEmptyAppBar extends StatelessWidget {
  const CustomEmptyAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      hasBorder: true,
      pinned: true,
      leading: GestureDetector(
        onTap: () => NavigatorKeyManager().pop(),
        child: Icon(
          Icons.arrow_back_ios,
          color: context.appColors.primary,
          size: 24.w,
        ),
      ),
    );
  }
}
