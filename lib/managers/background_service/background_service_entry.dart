import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';
import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:beat_flutter/managers/permission/permission_manager.dart';
import 'package:beat_flutter/managers/prefs/prefs_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// import 'package:location/location.dart';
import 'package:pedometer/pedometer.dart';

class LatLng {
  final double lat;
  final double lng;

  LatLng(this.lat, this.lng);
}

@pragma('vm:entry-point')
Future<void> startServiceAndroid(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  // DartPluginRegistrant.ensureInitialized();

  await DotEnvManager().ensureInitialized();
  await PermissionManager.updateLocationAndActivityPemission();
  await PrefsManager().init();

  log("FlutterBackgroundService started");

  Locale primary = PlatformDispatcher.instance.locale;
  String languageCode = primary.languageCode;

  PlatformDispatcher.instance.onLocaleChanged = () {
    final l = PlatformDispatcher.instance.locale;
    languageCode = l.languageCode;
  };

  String notificationContentInitial() => switch (languageCode) {
        "ko" => "BEAT가 실행 중입니다.",
        _ => "BEAT is running."
      };

  String notificationContentCountingSteps() => switch (languageCode) {
        "ko" => "BEAT가 걸음 수를 측정 중입니다.",
        _ => "BEAT is tracking your steps."
      };

  String notificationContentOutOfRange() => switch (languageCode) {
        "ko" => "걸음 수 측정 지역이 아닙니다. 걸음 수 기록이 일시 중지됩니다.",
        _ =>
          "This is not a step-tracking area. Step tracking is temporarily paused."
      };

  String notificationContentNotEventDurationContent() => switch (languageCode) {
        "ko" => "걸음 수 측정 시간이 아닙니다. 걸음 수 기록이 일시 중지됩니다.",
        _ =>
          "It is not the step-tracking time. Step tracking is temporarily paused."
      };

  /// 포어그라운드 서비스 알림 기본값
  const String notificationTitle = "BEAT: Event and Activity";
  String notificationContent = notificationContentInitial();

  ///
  final RxList<Map<String, dynamic>> walkReports = <Map<String, dynamic>>[].obs;

  /// 걸음 수 이벤트 구독 스트림
  StreamSubscription<StepCount>? stepSubscription;

  /// 보행 상태 이벤트 구독 스트림
  // StreamSubscription<PedestrianStatus>? statusSubscription;

  /// 위치 정보 스트림
  StreamSubscription<Position>? positionSubscription;

  /// 권한 변경 상태 감지 스트림
  StreamSubscription<ServiceStatus>? serviceStatusSub;

  /// 위치 갱신 타이머
  /// 공유일에는 위치 추적이 중지됨
  // Timer? locationTimer;

  /// 자정 초기화 타이머
  /// 절대로 이 타이머는 멈추면 안됨
  /// (테스트용으로 5분마다 0초에 초기화 신호 전송)
  Timer? midnightOnce;

  /// 1시간 단위 걸음 수 동기화 타이머
  Timer? hourlySyncTimer;

  /// 매 시간 특정 초에 랭킹 집계를 위해 서버로 걸음 수를 전송함
  Timer? rankSyncTimer;

  /// 권한 상태 점검 타이머
  Timer? permissionCheckTimer;

  /// 권한 상태 캐시
  bool? hasLocationPermission;
  bool? hasActivityPermission;

  /// 위치 정보 저장 변수
  // final location = Location();

  String authorization = '';
  int? stepsAfterLastBoot;
  int? previousSteps;
  int todayWalkCount = 0;
  int weeklyWalkCount = 0;
  int monthlyWalkCount = 0;
  int totalWalkCount = 0;
  DateTime lastReportedTime = DateTime.now();
  int lastReportedSteps = 0;
  bool isInValidArea = false;

  int startCount = 0;

  /// 랭킹 집계를 위해 서버로 걸음 수를 전송할 때, 몇 초에 전송할 것인지를 저장하는 변수
  /// 실제로 background isolate에서는 데이터를 전송하지 않고, [FlutterBackgroundService]의
  /// 채널 핸들러를 통해 UI isolate로 신호를 보내고, 이를 UI isolate에서 처리함.
  /// 이 값은 로그인 성공 -> 라우팅 관리 클래스에서 [ActivityServiceController.setAuthorization] 호출 ->
  /// [PedometerController]의 authorization 설정 -> [ActivityServiceController.setSendToTime] 호출
  /// -> [ActivityController]의 sentToTime 설정 -> [ScreenHolder.initState] ->
  /// [ScreenHolder.showDialogIfPermissionDenied] ->
  /// [Get.find<ActivityServiceController>().startService();] ->
  /// [ActivityController]Android 분기에서
  /// [service.invoke("setSendToTime", {"value": sendToTime});]으로 전달
  ///
  int sendToTime = 0;

  /// 공휴일 여부
  /// 실제로 background isolate에서는 데이터를 전송하지 않고, [FlutterBackgroundService]의
  /// 채널 핸들러를 통해 UI isolate로 신호를 보내고, 이를 UI isolate에서 처리함.
  /// 이 값은 로그인 성공 -> 라우팅 관리 클래스에서 [ActivityServiceController.setAuthorization] 호출 ->
  /// [PedometerController]의 authorization 설정 -> [ActivityServiceController.setSendToTime] 호출
  /// -> [ActivityController]의 sentToTime 설정 -> [ActivityController]Android 분기에서
  /// -> [ActivityController]의 sentToTime 설정 -> [ScreenHolder.initState] ->
  /// [ScreenHolder.showDialogIfPermissionDenied] ->
  /// [Get.find<ActivityServiceController>().startService();] ->
  /// [ActivityController]Android 분기에서
  /// [service.invoke("updateHolidayStatus", {"isHoliday": isHoliday});]로 전달
  ///
  bool isHoliday = true;

  bool isLocationServiceEnabled = false;

  /// 모든 구독 스트림과 타이머를 취소
  void cancelAll() {
    stepSubscription?.cancel();
    // statusSubscription?.cancel();
    positionSubscription?.cancel();
    midnightOnce?.cancel();
    hourlySyncTimer?.cancel();
    rankSyncTimer?.cancel();
    permissionCheckTimer?.cancel();
    serviceStatusSub?.cancel();

    stepSubscription = null;
    // statusSubscription = null;
    positionSubscription = null;
    midnightOnce = null;
    hourlySyncTimer = null;
    rankSyncTimer = null;
    permissionCheckTimer = null;
    serviceStatusSub = null;
  }

  void updateUISteps() {
    service.invoke(
      "updateUISteps",
      {
        "todayWalkCount": todayWalkCount,
        "weeklyWalkCount": weeklyWalkCount,
        "monthlyWalkCount": monthlyWalkCount,
        "totalWalkCount": totalWalkCount
      },
    );
  }

  void setValidArea(bool value, {bool force = false}) {
    if (!force && isInValidArea == value) return; // 변경 있을 때만 전파
    isInValidArea = value;
    service.invoke("updateIsInValidArea", {"isInValidArea": value});

    if (service is AndroidServiceInstance) {
      final content = value
          ? notificationContentCountingSteps()
          : notificationContentOutOfRange();
      service.setForegroundNotificationInfo(
        title: notificationTitle,
        content: content,
      );
    }
  }

  /// API 요청을 통해 오늘이 공휴일인지를 확인.
  /// 서버는 이번 달의 공휴일 리스트를 응답하는데, 이 리스트에 오늘 날짜가 포함되었는지, 오늘이 토요일 혹은 일요일인지를 확인한다.
  /// 상태코드가 200이 아니거나 오류 발생 시에는 false를 반환한다.
  Future<bool> getIsHoliday() async {
    final DateTime now = DateTime.now();
    final String requestUrl =
        "${DotEnvManager().holidayList}?year=${now.year}&month=${(now.month).toString().padLeft(2, "0")}";

    try {
      final http.Response response = await http
          .get(Uri.parse(requestUrl))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final List<dynamic> responseBody = jsonDecode(response.body);
        final String nowFormatted = DateFormat("yyyy-MM-dd").format(now);
        return (responseBody.any((e) => e["date"] == nowFormatted)) ||
            now.weekday == DateTime.saturday ||
            now.weekday == DateTime.sunday;
      }
      return false;
    } catch (e) {
      return false;
    }
    // return false;
  }

  Future<void> getWalkHitory() async {
    final String requestURL = DotEnvManager().walkHistoryUrl;

    try {
      final (savedToday, savedWeekly, savedMonthly, savedTotal) =
          PrefsManager().getSteps();

      final savedLastReportedSteps = PrefsManager().getLastReportedSteps();

      final response = await http.get(
        Uri.parse(requestURL),
        headers: {"Authorization": authorization},
      );

      if (response.statusCode == 200) {
        final bodyToJson = jsonDecode(response.body);

        if (savedToday > bodyToJson['todayWalkCount']) {
          todayWalkCount = savedToday;
          weeklyWalkCount = savedWeekly;
          monthlyWalkCount = savedMonthly;
          totalWalkCount = savedTotal;
        } else {
          todayWalkCount = bodyToJson['todayWalkCount'];
          weeklyWalkCount = bodyToJson['weeklyWalkCount'];
          monthlyWalkCount = bodyToJson['monthlyWalkCount'];
          totalWalkCount = bodyToJson['totalWalkCount'];
        }
        lastReportedSteps = bodyToJson['todayWalkCount'];
      } else {
        todayWalkCount = savedToday;
        weeklyWalkCount = savedWeekly;
        monthlyWalkCount = savedMonthly;
        totalWalkCount = savedTotal;
        lastReportedSteps = savedLastReportedSteps;
      }
      PrefsManager().setSteps(
          todayWalkCount, weeklyWalkCount, monthlyWalkCount, totalWalkCount);
    } catch (e) {
      log('BackgroundService: getWalkHistory error: $e');
    }
  }

  /// [walkReports]에 새 보고 항목 추가
  /// lastReportedTime, lastReportedSteps 갱신
  /// 내부 저장소에 걸음 수, lastReportedTime, lastReportedSteps 저장
  void addWalkReport() async {
    final DateTime now = DateTime.now();
    final int reportStep = math.max(0, todayWalkCount - lastReportedSteps);

    walkReports.add({
      "historyDateTime":
          DateTime(now.year, now.month, now.day, now.hour + 1, 0, 0)
              .toIso8601String(),
      "walkCount": reportStep,
    });

    lastReportedTime = now;
    lastReportedSteps = todayWalkCount;

    PrefsManager().setSteps(
      todayWalkCount,
      weeklyWalkCount,
      monthlyWalkCount,
      totalWalkCount,
    );
    PrefsManager().setLastReportedTime(lastReportedTime);
    PrefsManager().setLastReportedSteps(lastReportedSteps);
  }

  Future<void> recoverMissedSteps() async {
    log("FlutterBackgroundService: recoverMissedSteps called");

    final latest = PrefsManager().getDeviceStepsLatest();

    final lastHandled = PrefsManager().getDeviceStepsLastHandled();

    final missed = latest - lastHandled;
    if (missed > 0 &&
        (PermissionManager.isActivityPermissionGrantedStatic ?? false) &&
        !isHoliday &&
        isInValidArea) {
      todayWalkCount += missed;
      weeklyWalkCount += missed;
      monthlyWalkCount += missed;
      totalWalkCount += missed;
      PrefsManager().setSteps(
          todayWalkCount, weeklyWalkCount, monthlyWalkCount, totalWalkCount);
      updateUISteps();
    }

    PrefsManager().setDeviceStepsLastHandled(latest);
  }

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

  bool isPointInAsanAreaBackground(double lat, double lon) {
    return isInsidePolygon(LatLng(lat, lon), asanArea);
  }

  bool isPointInCheonanAreaBackground(double lat, double lon) {
    return isInsidePolygon(LatLng(lat, lon), cheonanArea);
  }

  // 백그라운드 위치 업데이트용
  void checkIsValidAreaBackground(double lat, double lon) async {
    if (hasLocationPermission != true) {
      setValidArea(false);
      return;
    }

    final inside = isPointInAsanAreaBackground(lat, lon) ||
        isPointInCheonanAreaBackground(lat, lon);

    setValidArea(inside);
  }

  /// 권한 상태 업데이트
  Future<void> updateActivityAndLocationPermission() async {
    await PermissionManager.updateLocationAndActivityPemission();

    hasActivityPermission = PermissionManager.isActivityPermissionGrantedStatic;
    hasLocationPermission = PermissionManager.isLocationPermissionGrantedStatic;
  }

  /// 위치 스트림 설정
  void setPositionStream() {
    positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.best),
    ).listen(
      (position) {
        checkIsValidAreaBackground(position.latitude, position.longitude);
      },
      onDone: () {
        positionSubscription = null;
      },
      onError: (e) async {
        log('BackgroundService: location stream error: $e');
        await positionSubscription?.cancel();
        positionSubscription = null;
      },
      cancelOnError: true,
    );
  }

  Future<void> resetAtMidnight() async {
    isHoliday = await getIsHoliday();

    final DateTime now = DateTime.now();

    if (isHoliday) {
      positionSubscription?.cancel();
      positionSubscription = null;
    } else {
      setPositionStream();
    }

    const int saveSteps = 0;
    final int saveWeeklyWalkCount =
        now.weekday == DateTime.sunday ? 0 : weeklyWalkCount;
    final int saveMonthlyWalkCount = now.day == 1 ? 0 : monthlyWalkCount;
    final int saveTotalWalkCount = totalWalkCount;

    todayWalkCount = saveSteps;
    weeklyWalkCount = saveWeeklyWalkCount;
    monthlyWalkCount = saveMonthlyWalkCount;

    PrefsManager().setSteps(
      saveSteps,
      saveWeeklyWalkCount,
      saveMonthlyWalkCount,
      saveTotalWalkCount,
    );

    lastReportedSteps = 0;
    PrefsManager().setLastReportedSteps(0);

    service.invoke(
      "midnightReset",
      {
        "isHoliday": isHoliday,
        "todayWalkCount": todayWalkCount,
        "weeklyWalkCount": weeklyWalkCount,
        "monthlyWalkCount": monthlyWalkCount,
        "totalWalkCount": totalWalkCount
      },
    );

    // ✅ 오늘자로 리셋 마커 업데이트 (중복 리셋 방지)
    final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    PrefsManager().setLastResetYmd(todayKey);
  }

  Future<void> maybeResetIfNeeded() async {
    final now = DateTime.now();
    final String todayKey = DateFormat('yyyy-MM-dd').format(now);
    final String lastKey = PrefsManager().getLastResetYmd(); // 없으면 ""

    // ✅ 첫 실행: 리셋하지 말고 ‘오늘자 마커’만 세팅
    if (lastKey.isEmpty) {
      PrefsManager().setLastResetYmd(todayKey);
      return;
    }

    if (lastKey != todayKey) {
      await resetAtMidnight();
      PrefsManager().setLastResetYmd(todayKey);
    }
  }

  /// 백그라운드 걸음 수 이벤트 처리
  void onStepCountFromNative(int stepsFromNative) {
    maybeResetIfNeeded();

    // 1) 베이스라인은 항상 갱신
    if (stepsAfterLastBoot == null ||
        (stepsAfterLastBoot != null && stepsAfterLastBoot! > stepsFromNative)) {
      stepsAfterLastBoot = stepsFromNative;
      PrefsManager().setStepsAfterLastboot(stepsAfterLastBoot!);
    }

    // 2) 이전 디바이스 스텝을 항상 최신으로 유지
    if (previousSteps == null ||
        (previousSteps != null && previousSteps! > stepsFromNative)) {
      previousSteps = stepsFromNative;
    }

    int diff = stepsFromNative - previousSteps!;
    previousSteps = stepsFromNative;

    // 3) 합산은 조건 만족할 때만
    if (hasActivityPermission != true ||
        !isInValidArea ||
        isHoliday ||
        diff <= 0) {
      return;
    }

    // steps += diff;
    todayWalkCount += diff;
    weeklyWalkCount += diff;
    monthlyWalkCount += diff;
    totalWalkCount += diff;

    // 증가 시점마다 즉시 영속화
    PrefsManager().setSteps(
      todayWalkCount,
      weeklyWalkCount,
      monthlyWalkCount,
      totalWalkCount,
    );

    updateUISteps();
  }

  /// 걸음 수 및 보행 상태 스트림 설정
  void setStepAndPedestrianStatusStream() {
    final stepStream = Pedometer.stepCountStream;
    stepSubscription = stepStream.listen(
      (event) {
        onStepCountFromNative(event.steps);
      },
      onDone: () {
        stepSubscription = null;
      },
      onError: (e) async {
        log('BackgroundService: pedometer stream error: $e');
        await stepSubscription?.cancel();
        stepSubscription = null;
      },
      cancelOnError: true,
    );
  }

  /// 스트림이 설정중인지를 나타내는 플래그.
  /// 일종의 mutex?
  /// 스트림 설정 중 새로운 스트림 설정 요청이 들어왔을 때
  /// 스트림을 중복으로 설정하는 문제를 방지하기 위함
  bool setting = false;

  /// 구독 스트림을 안전하게 설정하는 함수
  /// 함수 진입 시 setting 플래그를 설정
  /// 우선 위치, 활동 권한이 있는지를 확인한 후,
  /// 위치 스트림, 걸음 수, 보행 상태 스트림을 중지
  /// 이후 각 스트림이 이미 구독중인지를 확인하고 구독중이 아니라면 스트림을 설정
  /// 함수 종료 시 setting 플래그를 false로 설정
  Future<void> safeSetStreams() async {
    log("FlutterBackgroundService: safeSetStreams called");

    if (setting) return;
    setting = true;
    try {
      await updateActivityAndLocationPermission();

      log("FlutterBackgroundService: safeSetStreams: hasLocationPermission: $hasLocationPermission, hasActivityPermission: $hasActivityPermission, isHoliday: $isHoliday, isInValidArea: $isInValidArea");

      if (hasLocationPermission != true || hasActivityPermission != true) {
        await positionSubscription?.cancel();
        positionSubscription = null;

        await stepSubscription?.cancel();
        stepSubscription = null;

        // await statusSubscription?.cancel();
        // statusSubscription = null;
        return;
      }
      if (isHoliday) {
        await positionSubscription?.cancel();
        positionSubscription = null;
      } else if (positionSubscription == null) {
        try {
          final last = await Geolocator.getLastKnownPosition();
          if (last != null) {
            checkIsValidAreaBackground(last.latitude, last.longitude);
          }

          final pos = await Geolocator.getCurrentPosition(
            locationSettings:
                const LocationSettings(accuracy: LocationAccuracy.best),
          );
          checkIsValidAreaBackground(pos.latitude, pos.longitude);
        } catch (e) {
          log('getCurrentPosition error: $e');
        }
        setPositionStream();
      }
      if (stepSubscription == null) {
        setStepAndPedestrianStatusStream();
      }
    } finally {
      setting = false;
    }
  }

  void setPermissionCheckTimer() {
    permissionCheckTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      safeSetStreams();
    });
  }

  void setServiceStatusSub() {
    serviceStatusSub = Geolocator.getServiceStatusStream().listen(
      (s) async {
        if (s == ServiceStatus.enabled) {
          isLocationServiceEnabled = true;
          maybeResetIfNeeded();
          // isInValidArea = true;
          // service.invoke("updateIsInValidArea", {"isInValidArea": true});

          await safeSetStreams();
        } else {
          isLocationServiceEnabled = false;

          setValidArea(false);

          // isInValidArea = false;
          // service.invoke("updateIsInValidArea", {"isInValidArea": false});

          stepSubscription?.cancel();
          stepSubscription = null;

          positionSubscription?.cancel();
          positionSubscription = null;
        }
      },
      onDone: () {
        serviceStatusSub = null;
      },
      onError: (e) async {
        isLocationServiceEnabled = false;

        setValidArea(false);

        // isInValidArea = false;
        // service.invoke("updateIsInValidArea", {"isInValidArea": false});

        await serviceStatusSub?.cancel();
        serviceStatusSub = null;
      },
      cancelOnError: true,
    );
  }

  void scheduleMidnightOnce() {
    // 자정(테스트: 5분마다 0초)에 리셋 트리거
    midnightOnce?.cancel();
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final diff = tomorrow.difference(now);
    midnightOnce = Timer(diff, () async {
      // midnightOnce = Timer(const Duration(minutes: 1), () async {
      await resetAtMidnight();
      scheduleMidnightOnce();
    });
  }

  void setHourlySyncTimer() {
    // 1시간마다 동기화 트리거
    hourlySyncTimer = Timer.periodic(const Duration(hours: 1), (_) async {
      maybeResetIfNeeded();
      addWalkReport();
      updateUISteps();
    });
  }

  void setRankSyncTimer() {
    // 매 시간 59분 특정 초에 랭킹 동기화 트리거
    rankSyncTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      final now = DateTime.now();
      if (now.minute == 59 && now.second == sendToTime) {
        // if (now.minute % 3 == 0 && now.second == sendToTime) {
        addWalkReport();
        updateUISteps();
      }
    });
  }

  void startBackgroundService() async {
    log("FlutterBackgroundService: startBackgroundService called");

    isHoliday = await getIsHoliday();

    final enabled = await Geolocator.isLocationServiceEnabled();
    isLocationServiceEnabled = enabled;
    if (!enabled) setValidArea(false);

    lastReportedTime = PrefsManager().getLastReportedTime();
    lastReportedSteps = PrefsManager().getLastReportedSteps();
    stepsAfterLastBoot = PrefsManager().getStepsAfterLastboot();
    walkReports.assignAll(PrefsManager().getUnsentStepsList());

    await getWalkHitory();

    log("FlutterBackgroundService: startBackgroundService: lastReportedTime: $lastReportedTime, lastReportedSteps: $lastReportedSteps, stepsAfterLastBoot: $stepsAfterLastBoot, unsentStepsList: $walkReports");

    ever<List<Map<String, dynamic>>>(
      walkReports,
      (reports) async {
        if (reports.isEmpty) return;

        final String requestUrl = DotEnvManager().walkRecordUrl;
        final (savedToday, savedWeekly, savedMonthly, savedTotal) =
            PrefsManager().getSteps();

        try {
          final http.Response response = await http.post(
            Uri.parse(requestUrl),
            headers: {
              "Authorization": authorization,
              "Content-Type": "application/json",
            },
            body: jsonEncode(walkReports),
          );

          if (response.statusCode == 200) {
            final bodyToJson = jsonDecode(response.body);
            if (lastReportedTime.day != DateTime.now().day) {
              todayWalkCount = bodyToJson['todayWalkCount'];
              weeklyWalkCount = bodyToJson['weeklyWalkCount'];
              monthlyWalkCount = bodyToJson['monthlyWalkCount'];
              totalWalkCount = bodyToJson['totalWalkCount'];
            } else {
              if (savedToday >= bodyToJson['todayWalkCount']) {
                todayWalkCount = savedToday;
                weeklyWalkCount = savedWeekly;
                monthlyWalkCount = savedMonthly;
                totalWalkCount = savedTotal;
              } else {
                todayWalkCount = bodyToJson['todayWalkCount'];
                weeklyWalkCount = bodyToJson['weeklyWalkCount'];
                monthlyWalkCount = bodyToJson['monthlyWalkCount'];
                totalWalkCount = bodyToJson['totalWalkCount'];
              }
            }
            lastReportedSteps = bodyToJson['todayWalkCount'];

            // ✅ 성공 시에만 큐 비우기 및 영속화
            walkReports.clear();
            await PrefsManager().setUnsentStepsList(walkReports);
          } else {
            if (lastReportedTime.day != DateTime.now().day) {
              resetAtMidnight();
            } else {
              todayWalkCount = savedToday;
              weeklyWalkCount = savedWeekly;
              monthlyWalkCount = savedMonthly;
              totalWalkCount = savedTotal;
              lastReportedSteps = savedToday;
            }

            // ❌ 실패: 큐 유지, 현재 큐를 영속화
            await PrefsManager().setUnsentStepsList(reports);
          }
        } catch (e) {
          log("BackgroundService: send walk report error: $e");
          // 예외: 큐 유지, 현재 큐를 영속화
          await PrefsManager().setUnsentStepsList(reports);
        }
      },
    );

    // await recoverMissedSteps();

    // ✅ 첫 실행이면 리셋 금지: 마커만 세팅, 아니면 평소처럼 체크
    final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final lastKey = PrefsManager().getLastResetYmd();
    if (lastKey.isEmpty) {
      PrefsManager().setLastResetYmd(todayKey);
    } else {
      await maybeResetIfNeeded();
    }

    safeSetStreams();
    setServiceStatusSub();
    setPermissionCheckTimer();
    scheduleMidnightOnce();
    setHourlySyncTimer();
    setRankSyncTimer();
    startCount = 0;

    service.invoke(
      "bg_started",
      {
        "isHoliday": isHoliday,
        "isInValidArea": isInValidArea,
        "todayWalkCount": todayWalkCount,
        "weeklyWalkCount": weeklyWalkCount,
        "monthlyWalkCount": monthlyWalkCount,
        "totalWalkCount": totalWalkCount
      },
    );

    updateUISteps();
    setValidArea(isInValidArea, force: true);
  }

  /// FlutterBackgroundService 이벤트 핸들러
  service.on("startBackgroundTasks").listen((data) {
    log("FlutterBackgroundService: startBackgroundTasks called: data: $data");

    if (startCount >= 3) return;
    if (data == null) {
      service.invoke("bg_ready");
      startCount++;
    } else if (data["authorization"] == null || data["sendToTime"] == null) {
      service.invoke("bg_ready");
      startCount++;
    } else {
      authorization = data['authorization'];
      sendToTime = data['sendToTime'];

      startBackgroundService();
    }
  });

  /// FlutterBackgroundService 중지
  service.on('stopService').listen((event) async {
    log('BackgroundService: stopService received');
    cancelAll();
    if (service is AndroidServiceInstance) {
      await service.stopSelf();
    }
  });

  service.on("addWalkReport").listen((_) {
    addWalkReport();
  });

  /// 실제 동작 실행
  /// 초기 알림 설정
  if (service is AndroidServiceInstance) {
    await service.setForegroundNotificationInfo(
      title: notificationTitle,
      content: notificationContent,
    );
    await service.setAsForegroundService();
  }

  /// 30초 간격으로 알림 업데이트
  if (service is AndroidServiceInstance) {
    Timer.periodic(const Duration(seconds: 30), (timer) async {
      if (await service.isForegroundService()) {
        if (isHoliday) {
          notificationContent = notificationContentNotEventDurationContent();
        } else if (!isInValidArea) {
          notificationContent = notificationContentOutOfRange();
        } else {
          notificationContent = notificationContentCountingSteps();
        }

        await service.setForegroundNotificationInfo(
          title: notificationTitle,
          content: notificationContent,
        );
      }
    });
  }

  service.invoke('bg_ready');
  // log("FlutterBackgroundService : bg_ready invoked");
}

@pragma('vm:entry-point')
Future<void> startServiceIOS(ServiceInstance service) async {}

@pragma('vm:entry-point')
Future<bool> startBackgroundServiceIOS(ServiceInstance service) async {
  return true;
}
