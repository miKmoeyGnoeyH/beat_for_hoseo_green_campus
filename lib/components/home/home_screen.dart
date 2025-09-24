import 'package:beat_flutter/components/global/widgets/custom_rounded_bordered_container.dart';
import 'package:beat_flutter/components/home/widgets/home_contents.dart';
import 'package:beat_flutter/components/home/widgets/pedometer_card.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/permission/permission_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'widgets/neuroes_in_hand_card.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final PageController pageController = PageController();
  late Future<void> _permissionFuture;

  final List<Widget> widgets = [
    const PedometerCard(),
    PointsInHandCard(),
  ];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    debugPrint('didChangeAppLifecycleState: $state');
    switch (state) {
      case AppLifecycleState.resumed:
        setState(() {
          _permissionFuture =
              PermissionManager.updateLocationAndActivityPemission();
        });
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      default:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _permissionFuture = PermissionManager.updateLocationAndActivityPemission();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      // shrinkWrap: true,
      children: [
        Column(
          // shrinkWrap: true,
          // padding: EdgeInsets.zero,
          children: [
            SizedBox(
              width: double.infinity,
              height: 170.w,
              child: FutureBuilder(
                  future: _permissionFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 16.w),
                        child: CustomRoundedBorderedContainer(
                          color: context.appColors.primary,
                        ),
                      );
                    }
                    return PageView(
                      controller: pageController,
                      children: widgets,
                    );
                  }),
            ),
            SmoothPageIndicator(
              controller: pageController,
              count: widgets.length,
              effect: SlideEffect(
                activeDotColor: context.appColors.primary,
                dotColor: context.appColors.disabled,
                dotWidth: 10.w,
                dotHeight: 10.w,
              ),
            ),
            SizedBox(height: 16.w),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [const HomeContents(), SizedBox(height: 20.w)],
              ),
            )
          ],
        )
      ],
    );
  }
}
