import 'dart:io';

import 'package:beat_flutter/controller/pedometer/pedometer_controller.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/logger/beat_logger.dart';
import 'package:beat_flutter/managers/notification/local_notification.dart';
import 'package:beat_flutter/managers/permission/permission_manager.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LatLng {
  final double lat;
  final double lng;

  LatLng(this.lat, this.lng);
}

class LocationController extends GetxController {
  /// iOS 네이티브와 통신하기 위한 MethodChannel
  /// 모든 백그라운드 작업(걸음 수 동기화, 랭킹 집계, 자정 초기화)이 이 채널을 통해 이루어짐
  static const _locationChannel = MethodChannel("com.beat.walkreport/location");

  // 위치
  final Rx<LatLng?> _locationData = Rx<LatLng?>(null);

  LatLng? get locationData => _locationData.value;

  set locationData(LatLng? value) => _locationData.value = value;

  bool get hasLocation => locationData != null;

  // 언어
  final LocalizationManager localizationManager = LocalizationManager();

  LocationController();

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

      if (a.lng == b.lng) continue;

      if (a.lng > b.lng) {
        final temp = a;
        a = b;
        b = temp;
      }

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

  bool isPointInAsanAreaBackground(double lat, double lon) {
    return isInsidePolygon(LatLng(lat, lon), asanArea);
  }

  bool isPointInCheonanAreaBackground(double lat, double lon) {
    return isInsidePolygon(LatLng(lat, lon), cheonanArea);
  }

  // 백그라운드 위치 업데이트용
  void checkIsValidAreaBackground(double lat, double lon) async {
    final PedometerController pedometerController =
        Get.find<PedometerController>();

    // iOS: 자정 보정 가드 (안드로이드 분기 미변경)
    if (Platform.isIOS) {
      pedometerController.ensureDailyResetGuard();
    }

    if (PermissionManager.isLocationPermissionGrantedStatic != true) {
      pedometerController.isInValidArea = false;
      return;
    }

    if (!isPointInAsanAreaBackground(lat, lon) &&
        !isPointInCheonanAreaBackground(lat, lon)) {
      if (!pedometerController.isInValidArea) return;
      pedometerController.isInValidArea = false;

      BEATLogger.d(
          "LocationController : checkIsValidAreaBackground() : User Location Out of Range : $lat, $lon");

      LocalNotificationManager.showValidAreaNotification(
        localizationManager.lnOutOfRangeTitle,
        localizationManager.lnOutOfRangeBody,
      );
    } else {
      if (pedometerController.isInValidArea) return;
      pedometerController.isInValidArea = true;

      BEATLogger.d(
          "LocationController : checkIsValidAreaBackground() : User Location Back in Range : $lat, $lon");

      LocalNotificationManager.showValidAreaNotification(
        localizationManager.lnBackInRangeTitle,
        localizationManager.lnBackInRangeBody,
      );
    }
  }

  /// 백그라운드 에서 정확한 시간(매시간 정각)에 호출되는 백그라운드 걸음 수 동기화
  Future<void> syncWalkDataInBackground() async {
    BEATLogger.d("LocationController : syncWalkDataInBackground()");
    try {
      // iOS: 자정 보정 가드
      if (Platform.isIOS) {
        final pedometerController = Get.find<PedometerController>();
        pedometerController.ensureDailyResetGuard();
      }
      await PermissionManager.updateLocationAndActivityPemission();
      if (PermissionManager.isActivityPermissionGrantedStatic! &&
          PermissionManager.isLocationPermissionGrantedStatic!) {
        final pedometerController = Get.find<PedometerController>();
        pedometerController.addWalkReport();
        BEATLogger.d("LocationController : 백그라운드 걸음 수 동기화 완료");
      } else {
        BEATLogger.d("LocationController : 권한이 없어 걸음 수 동기화 건너뜀");
      }
    } catch (e) {
      BEATLogger.e("LocationController : 백그라운드 걸음 수 동기화 실패: $e");
    }
  }

  /// 백그라운드에서 정확한 시간(매시간 정각)에 호출되는 백그라운드 랭킹 집계
  Future<void> syncRankingInBackground() async {
    BEATLogger.d("LocationController : syncRankingInBackground()");
    try {
      // iOS: 자정 보정 가드
      if (Platform.isIOS) {
        final pedometerController = Get.find<PedometerController>();
        pedometerController.ensureDailyResetGuard();
      }
      await PermissionManager.updateLocationAndActivityPemission();
      if (PermissionManager.isActivityPermissionGrantedStatic! &&
          PermissionManager.isLocationPermissionGrantedStatic!) {
        final pedometerController = Get.find<PedometerController>();
        pedometerController.addWalkReport();
        BEATLogger.d("LocationController : 백그라운드 랭킹 집계 완료 - 걸음 수 전송됨");
      } else {
        BEATLogger.d("LocationController : 권한이 없어서 랭킹 집계 건너뜀");
      }
    } catch (e) {
      BEATLogger.e("LocationController : 백그라운드 랭킹 집계 실패: $e");
    }
  }

  Future<void> getLocation() async {
    final Position position = await Geolocator.getCurrentPosition();

    locationData = LatLng(
      position.latitude,
      position.longitude,
    );
  }
}
