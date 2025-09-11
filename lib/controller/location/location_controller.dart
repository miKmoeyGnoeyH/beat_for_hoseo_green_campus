import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

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

    // log("LocationController : checkIsValidArea() : isPointInAsanArea(): ${isPointInAsanArea()}, isPointInCheonanArea(): ${isPointInCheonanArea()}, pedometerController.isInValidArea: ${pedometerController.isInValidArea}");

    if (!isPointInAsanArea() && !isPointInCheonanArea()) {
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

  // ===아산캠퍼스===
  //
  // 학생회관 아래 시작(반시계)
  //
  // 36.73905847633573는.07441645479297
  //
  // 36.73912287279299, 127.07227801510604
  //
  // 36.73684411973639, 127.07046772248447
  //
  // 36.73573576644016, 127.07042192605417
  //
  // 36.73516838296647, 127.06987281506066
  //
  // 36.73499676688655, 127.07055560002914
  //
  // 36.73551867439705, 127.07179881381333
  //
  // 36.735284149061435, 127.07218485008256
  //
  // 36.73539632511584, 127.07294626975272
  //
  // 36.73460225454914, 127.07469204585705
  //
  // 36.73360175547217, 127.07509411621912
  //
  // 36.7326814599723, 127.07689568084213
  //
  // 36.73303259290043, 127.07736624033019
  //
  // 36.73454715737327, 127.07631536610076
  //
  // 36.736222818531225, 127.07697758417414
  //
  // 36.73880014890887, 127.07678982054752
  //
  // 36.738827370019735, 127.07649874382037
  //
  // 36.7393687288168, 127.07542442851555
  //
  // 36.739477490720276, 127.07442805567023
  //
  // =======
  //
  // ===천안캠퍼스===
  //
  // 가장 위(스타벅스 우측) 꼭짓점 시작
  //
  // 36.830327274558805, 127.18020021753239
  //
  // 36.83009097680529, 127.18003992692661
  //
  // 36.82990371331767, 127.18022724802745
  //
  // 36.82876674420636, 127.17977900834666
  //
  // 36.82839453209551, 127.18159404825123
  //
  // 36.826534838425715, 127.18235186916161
  //
  // 36.82608035605323, 127.18197528960386
  //
  // 36.82530941393403, 127.18229852140279
  //
  // 36.82545220384936, 127.1832011762635
  //
  // 36.82589369313384, 127.18323585563941
  //
  // 36.82641869776802, 127.18462142354441
  //
  // 36.8283930017052, 127.1840544914855
  //
  // 36.828461000619335, 127.18378563032861
  //
  // 36.82863829677594, 127.18276039787843
  //
  // 36.829313469671476, 127.1817195240613
  //
  // 36.829603672754665, 127.18198363368744
  //
  // ======

  List<LatLng> asanArea = [
    LatLng(36.73905847633573, 127.07441645479297),
    LatLng(36.73912287279299, 127.07227801510604),
    LatLng(36.73684411973639, 127.07046772248447),
    LatLng(36.73573576644016, 127.07042192605417),
    LatLng(36.73516838296647, 127.06987281506066),
    LatLng(36.73499676688655, 127.07055560002914),
    LatLng(36.73551867439705, 127.07179881381333),
    LatLng(36.735284149061435, 127.07218485008256),
    LatLng(36.73539632511584, 127.07294626975272),
    LatLng(36.73460225454914, 127.07469204585705),
    LatLng(36.73360175547217, 127.07509411621912),
    LatLng(36.7326814599723, 127.07689568084213),
    LatLng(36.73303259290043, 127.07736624033019),
    LatLng(36.73454715737327, 127.07631536610076),
    LatLng(36.736222818531225, 127.07697758417414),
    LatLng(36.73880014890887, 127.07678982054752),
    LatLng(36.738827370019735, 127.07649874382037),
    LatLng(36.7393687288168, 127.07542442851555),
    LatLng(36.739477490720276, 127.07442805567023),
  ];

  List<LatLng> cheonanArea = [
    LatLng(36.830327274558805, 127.18020021753239),
    LatLng(36.83009097680529, 127.18003992692661),
    LatLng(36.82990371331767, 127.18022724802745),
    LatLng(36.82876674420636, 127.17977900834666),
    LatLng(36.82839453209551, 127.18159404825123),
    LatLng(36.826534838425715, 127.18235186916161),
    LatLng(36.82608035605323, 127.18197528960386),
    LatLng(36.82530941393403, 127.18229852140279),
    LatLng(36.82545220384936, 127.1832011762635),
    LatLng(36.82589369313384, 127.18323585563941),
    LatLng(36.82641869776802, 127.18462142354441),
    LatLng(36.8283930017052, 127.1840544914855),
    LatLng(36.828461000619335, 127.18378563032861),
    LatLng(36.82863829677594, 127.18276039787843),
    LatLng(36.829313469671476, 127.1817195240613),
    LatLng(36.829603672754665, 127.18198363368744),
  ];

  bool isInsidePolygon(LatLng point, List<LatLng> polygon) {
    int intersectCount = 0;

    for (int i = 0; i < polygon.length; i++) {
      LatLng a = polygon[i];
      LatLng b = polygon[(i + 1) % polygon.length];

      if (a.lng == b.lng) continue; // 수직선은 제외

      // a.lng <= b.lng 순으로 정렬
      if (a.lng > b.lng) {
        final temp = a;
        a = b;
        b = temp;
      }

      // 현재 점이 선분의 Y 범위 내에 있는지 체크
      if (point.lng > a.lng && point.lng <= b.lng) {
        final slope = (b.lat - a.lat) / (b.lng - a.lng);
        final intersectLat = slope * (point.lng - a.lng) + a.lat;

        if (point.lat < intersectLat) {
          intersectCount++;
        }
      }
    }

    return (intersectCount % 2 == 1);
  }

  bool isPointInAsanArea() {
    if (!hasLocation) return false;
    return isInsidePolygon(locationData!, asanArea);
  }

  bool isPointInCheonanArea() {
    if (!hasLocation) return false;
    return isInsidePolygon(locationData!, cheonanArea);
  }
}
