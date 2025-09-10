import 'dart:async';
import 'dart:math';

import 'package:beat_flutter/controller/pedometer/pedometer_controller.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/logger/beat_logger.dart';
import 'package:beat_flutter/managers/notification/local_notification.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class LatLng {
  final double lat;
  final double lng;

  LatLng(this.lat, this.lng);
}

class LocationController extends GetxController {
  LocationController() {
    // startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // 위치
  final Rx<LatLng?> _locationData = Rx<LatLng?>(null);

  LatLng? get locationData => _locationData.value;

  set locationData(LatLng? value) => _locationData.value = value;

  bool get hasLocation => locationData != null;

  // 언어
  final LocalizationManager localizationManager = LocalizationManager();

  // 지속적으로 사용자 위치를 갱신해 유효 범위 내에 있는지를 확인하기 위한 타이머
  Timer? _timer;

  void startTimer() {
    BEATLogger.d("LocationController : startTimer() : timer started");

    _timer?.cancel();
    // _timer = Timer.periodic(const Duration(seconds: 10), (Timer t) async {
    // _timer = Timer.periodic(const Duration(seconds: 5), (Timer t) async {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer t) async {
      await fetchLocation();
      checkIsValidArea();
    });
  }

  Future<void> fetchLocation() async {
    final Location location = Location();
    final LocationData newLocationData = await location.getLocation();

    if (newLocationData.latitude == null || newLocationData.longitude == null) {
      return;
    }

    locationData =
        LatLng(newLocationData.latitude!, newLocationData.longitude!);
  }

  void checkIsValidArea() {
    final PedometerController pedometerController =
        Get.find<PedometerController>();

    if (!isPointInAsanArea()) {
      if (!pedometerController.isInValidArea) return;
      pedometerController.isInValidArea = false;
      LocalNotificationManager.showValidAreaNotification(
          localizationManager.lnOutOfRangeTitle,
          localizationManager.lnOutOfRangeBody);
    } else {
      if (pedometerController.isInValidArea) return;
      pedometerController.isInValidArea = true;
      LocalNotificationManager.showValidAreaNotification(
          localizationManager.lnBackInRangeTitle,
          localizationManager.lnBackInRangeBody);
    }
  }

  List<LatLng> asanArea = [
    LatLng(36.736752, 127.073291),
    LatLng(36.736690, 127.073230),
    LatLng(36.736798, 127.072927),
    LatLng(36.736928, 127.073090),
  ];

  bool isPointInAsanArea() {
    int intersectCount = 0;

    for (int i = 0; i < asanArea.length; i++) {
      LatLng a = asanArea[i];
      LatLng b = asanArea[(i + 1) % asanArea.length];

      // a.lng <= b.lng 되도록 정렬
      if (a.lng > b.lng) {
        var temp = a;
        a = b;
        b = temp;
      }

      if (hasLocation) {
        if (locationData!.lng > a.lng &&
            locationData!.lng <= b.lng &&
            locationData!.lat <= max(a.lat, b.lat) &&
            locationData!.lat >= min(a.lat, b.lat)) {
          double intersectLat =
              (b.lat - a.lat) * (locationData!.lng - a.lng) / (b.lng - a.lng) +
                  a.lat;

          if (locationData!.lat < intersectLat) {
            intersectCount++;
          }
        }
      } else {
        return false;
      }
    }

    // BEATLogger.d("LocationController : isPointInAsanArea() : locationData : ${locationData!.lat}, ${locationData!.lng}");
    // BEATLogger.d("LocationController : isPointInAsanArea() : intersectCount : $intersectCount");
    // BEATLogger.d("LocationController : isPointInAsanArea() : intersectCount % 2 == 1 : ${intersectCount % 2 == 1}");

    return (intersectCount % 2 == 1);
  }
}
