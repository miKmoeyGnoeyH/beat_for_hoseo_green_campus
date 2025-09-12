import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:beat_flutter/controller/pedometer/pedometer_controller.dart';

const platform = MethodChannel('com.beat.walkreport/channel');

void initializeWalkReportChannel() {
  platform.setMethodCallHandler((call) async {
    if (call.method == "updateStepsFromNative") {
      final steps = call.arguments["steps"] as int;
      final pedometer = Get.find<PedometerController>();
      pedometer.onStepCountFromNative(steps); // 새 메소드 따로 정의
    }
  });
}
