import 'package:app_settings/app_settings.dart';
import 'package:beat_flutter/components/global/widgets/buttons/custom_text_button_wrap.dart';
import 'package:beat_flutter/components/global/widgets/custom_rounded_bordered_container.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_body_large.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_headline_large.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_subtitle_large.dart';
import 'package:beat_flutter/components/home/widgets/pedometer_card.dart';
import 'package:beat_flutter/controller/pedometer/pedometer_controller.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/permission/permission_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PedometerCardStack extends StatefulWidget {
  const PedometerCardStack({super.key});

  @override
  State<PedometerCardStack> createState() => _PedometerCardStackState();
}

class _PedometerCardStackState extends State<PedometerCardStack>
    with WidgetsBindingObserver {
  final LocalizationManager localizationManager = LocalizationManager();
  late Future<void> _permissionFuture;

  final PedometerController pedometerController =
      Get.find<PedometerController>();

  int _todayWalkCountCache = 0;
  int _monthlyWalkCountCache = 0;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        setState(() {
          _permissionFuture =
              PermissionManager.updateLocationAndActivityPemission();
        });
        break;
      case AppLifecycleState.inactive:
        _todayWalkCountCache = pedometerController.todayWalkCount;
        _monthlyWalkCountCache = pedometerController.monthlyWalkCount;
        break;
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Stack(
        children: [
          FutureBuilder(
            future: _permissionFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return PedometerCard(_todayWalkCountCache, _monthlyWalkCountCache);
              } else {
                return Stack(
                  children: [
                    Obx(() {
                      return PedometerCard(pedometerController.todayWalkCount,
                          pedometerController.monthlyWalkCount);
                    }),
                    if ((PermissionManager.isLocationPermissionGrantedStatic !=
                                null &&
                            !PermissionManager
                                .isLocationPermissionGrantedStatic!) ||
                        (PermissionManager.isActivityPermissionGrantedStatic !=
                                null &&
                            !PermissionManager
                                .isActivityPermissionGrantedStatic!))
                      Positioned(
                        child: CustomRoundedBorderedContainer(
                          color: Colors.black.withValues(alpha: 0.8),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(5.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomSubtitleLarge(
                                    text: localizationManager
                                        .homeBEATRequiresLocationAndActivityPermissionTitle,
                                    textColor: context.appColors.onPrimary,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ),
                                  if (Localizations.localeOf(context)
                                          .languageCode ==
                                      "ko")
                                    CustomBodyLarge(
                                      text: localizationManager
                                          .homePleaseChangeTheLocationAndActivityPermissions,
                                      textColor: context.appColors.onPrimary,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                    ),
                                  const SizedBox(height: 10),
                                  CustomTextButtonWrap(
                                    text: localizationManager.homeGotoSettings,
                                    onTap: AppSettings.openAppSettings,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      Obx(
                        () {
                          if (!pedometerController.isInValidArea) {
                            return Positioned(
                              child: CustomRoundedBorderedContainer(
                                color: Colors.black.withValues(alpha: 0.8),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(5.w),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomSubtitleLarge(
                                          text: localizationManager
                                              .homeNotInValidArea,
                                          textColor:
                                              context.appColors.onPrimary,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else if (pedometerController.isHoliday) {
                            return Positioned(
                              child: CustomRoundedBorderedContainer(
                                color: Colors.black.withValues(alpha: 0.8),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(5.w),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomSubtitleLarge(
                                          text: localizationManager
                                              .homeNotEventDuration,
                                          textColor:
                                              context.appColors.onPrimary,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else if (pedometerController
                              .isReachedMaxStepCount) {
                            return Positioned(
                              child: CustomRoundedBorderedContainer(
                                color: Colors.black.withValues(alpha: 0.8),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(5.w),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomSubtitleLarge(
                                          text: localizationManager
                                              .homeReachedTodaysMaxStepCount,
                                          textColor:
                                              context.appColors.onPrimary,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
