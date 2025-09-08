import 'dart:async';

import 'package:get/get.dart';
import 'package:location/location.dart';

class LocationController extends GetxController {
  LocationController() {
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // 위치
  final Rx<LocationData?> _locationData = Rx<LocationData?>(null);

  LocationData? get locationData => _locationData.value;

  set locationData(LocationData? value) => _locationData.value = value;

  // 지속적으로 사용자 위치를 갱신해 유효 범위 내에 있는지를 확인하기 위한 타이머
  Timer? _timer;

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (Timer t) async {
      await fetchLocation();
    });
  }

  Future<void> fetchLocation() async {
    final Location location = Location();
    final LocationData newLocationData = await location.getLocation();

    locationData = newLocationData;
  }
}
