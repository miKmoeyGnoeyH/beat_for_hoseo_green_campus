import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:beat_flutter/managers/prefs/prefs_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:pedometer/pedometer.dart';
import 'package:http/http.dart' as http;

/// 자정 초기화를 구현하는 방법
/// 1. 앱이 백그라운드 -> 포어그라운드로 전환될 때마다 날짜를 비교, 날짜가 다르다면 초기화
///    앱이 백그라운드에 있는 상태에서 날짜가 변경됐을 때 -> 앱 생명주기가 변경되지 않아 날짜 초기화 안됨
///    자정 이후 걸음 수가 "어제" 걸음 수로 계산됨
/// 2. 앱 실행 시 현재 시각부터 자정까지의 차를 계산, 타이머 실행. 타이머가 종료되면 초기화
///    타이머로 인한 자원 낭비? 자정에 정확히 앱을 실행시켰을 때 -> 86400번의 타이머
///    iOS의 경우 백그라운드에서 앱이 일시정지됐을 때 타이머가 정지됨
///
/// flutter health 패키지 사용, 각 플랫폼 별 헬스 앱 연동하여 걸음 수 측정
///
class PedometerController extends GetxController {
  // 토큰
  String _authorization = '';

  String get authorization => _authorization;

  // 랭킹 집계를 위해 서버에 걸음 수를 전송할 때 몇 초에 전송할 것인지
  int _sendToTime = 0;

  int get sendToTime => _sendToTime;

  void setSendToTime(int value) {
    _sendToTime = value;
  }

  void setAuthorization(String authorization) {
    _authorization = authorization;
  }

  // 걸음 수 이벤트 스트림
  late Stream<StepCount> _stepCountStream;

  // 보행 상테 이벤트 스트림
  late Stream<PedestrianStatus> _pedestrianStatusStream;

  // 반응형 보행 상태 문자열
  final Rx<String> _status = ''.obs;

  String get status => _status.value;

  set status(String value) => _status.value = value;

  // 앱이 마지막으로 부팅된 이후의 걸음 수
  // View에서 보여지지 않음
  int? _stepsAfterLastBoot;

  // 반응형 앱 실행 이후 걸음 수(_stepsAfterLastBoot + 앱 실행 이후 걸음수)
  // View에서 보여지지 않음
  final Rx<int> _totalSteps = 0.obs;

  int get totalSteps => _totalSteps.value;

  set totalSteps(int value) => _totalSteps.value = value;

  // 반응형 앱 실행 이후 걸음 수 - 부팅 이후 걸음 수
  // 앱 실행 이후 걸음 수 = 부팅 이후 걸음 수 + 앱 실행 이후 걸음 수이므로
  // 순수한 앱 실행 이후 걸음 수만을 나타냄
  // View에서 보여질 걸음 수
  final Rx<int> _steps = 0.obs;

  int get steps => _steps.value;

  set steps(int value) => _steps.value = value;

  // 반응형 걸음 수
  final RxInt _todayWalkCount = 0.obs;

  int get todayWalkCount => _todayWalkCount.value;

  set todayWalkCount(int value) => _todayWalkCount.value = value;
  final RxInt _weeklyWalkCount = 0.obs;

  int get weeklyWalkCount => _weeklyWalkCount.value;

  set weeklyWalkCount(int value) => _weeklyWalkCount.value = value;
  final RxInt _monthlyWalkCount = 0.obs;

  int get monthlyWalkCount => _monthlyWalkCount.value;

  set monthlyWalkCount(int value) => _monthlyWalkCount.value = value;
  final RxInt _totalWalkCount = 0.obs;

  int get totalWalkCount => _totalWalkCount.value;

  set totalWalkCount(int value) => _totalWalkCount.value = value;

  // 이전 전송 걸음 수
  int _lastReportedSteps = 0;

  bool isInValidArea = false;

  // 일정 주기로 서버에 걸음 수를 보고할 때 사용하는 반응형 리스트
  final RxList<Map<String, dynamic>> _walkReports =
      <Map<String, dynamic>>[].obs;

  Timer? _reportTimer;
  Timer? _rankReportTimer;
  Timer? _midnightTimer;

  PedometerController() {
    initPlatformState();

    PrefsManager().setLastReportedSteps(0);
    _lastReportedSteps = PrefsManager().getLastReportedSteps();
    _walkReports.assignAll(PrefsManager().getUnsentStepsList());

    log("PedometerController: PedometerController: _lastReportedSteps: $_lastReportedSteps");
    log("PedometerController: PedometerController: _stepsAfterLastBoot: $_stepsAfterLastBoot");
    log("PedometerController: PedometerController: _totalSteps: $_totalSteps");
    log("PedometerController: PedometerController: _steps: $_steps");

    ever<List<Map<String, dynamic>>>(_walkReports, (reports) async {
      if (reports.isEmpty) return;

      final String requestUrl = DotEnvManager().walkRecordUrl;

      log(jsonEncode(_walkReports));

      try {
        final http.Response response = await http.post(Uri.parse(requestUrl),
            headers: {
              "Authorization": _authorization,
              "Content-Type": "application/json",
            },
            body: jsonEncode(_walkReports));

        final String responseBody = response.body;
        final Map<String, dynamic> bodyToJson = jsonDecode(responseBody);

        if (response.statusCode == 200) {
          todayWalkCount = bodyToJson['todayWalkCount'];
          weeklyWalkCount = bodyToJson['weeklyWalkCount'];
          monthlyWalkCount = bodyToJson['monthlyWalkCount'];
          totalWalkCount = bodyToJson['totalWalkCount'];
          steps = todayWalkCount;

          log("PedometerController : PedometerController : todayWalkCount : $todayWalkCount");
          log("PedometerController : PedometerController : weeklyWalkCount : $weeklyWalkCount");
          log("PedometerController : PedometerController : monthlyWalkCount : $monthlyWalkCount");
          log("PedometerController : PedometerController : totalWalkCount : $totalWalkCount");

          _walkReports.clear();
        } else {
          throw Exception();
        }
      } catch (e) {
        log("PedometerController : ever : ${e.toString()}");
      } finally {
        PrefsManager().setUnsentStepsList(reports);
      }
    });
  }

  @override
  dispose() {
    _reportTimer?.cancel();
    _rankReportTimer?.cancel();
    _midnightTimer?.cancel();
    super.dispose();
  }

  // 생성자에서 실행할 메소드.
  // 이벤트 스트림 구독, 걸음 수 초기값 설정.
  Future<void> initPlatformState() async {
    // log("PedometerController : initPlatformState");

    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    (_pedestrianStatusStream.listen(onPedestrianStatusChanged))
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
  }

  // 1시간에 한 번씩 걸음 수 동기화
  void addWalkReport() async {
    final DateTime now = DateTime.now();

    _walkReports.add({
      "historyDateTime":
          DateTime(now.year, now.month, now.day, now.hour + 1, 0, 0)
              .toIso8601String(),
      "walkCount": steps - _lastReportedSteps,
    });

    _lastReportedSteps = steps;
    PrefsManager().setLastReportedSteps(_lastReportedSteps);

    log("PedometerController: _addWalkReport: _lastReportedSteps: $_lastReportedSteps");
    log("PedometerController: _addWalkReport: _stepsAfterLastBoot: $_stepsAfterLastBoot");
    log("PedometerController: _addWalkReport: _totalSteps: $_totalSteps");
    log("PedometerController: _addWalkReport: _steps: $_steps");

    // log("PedometerController : _addWalkReport : _walkReports : ${_walkReports.toString()}");
  }

  Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: startTimer,
        onBackground: onIosBackground,
      ),
      androidConfiguration: AndroidConfiguration(
        autoStart: false,
        onStart: startTimer,
        isForegroundMode: false,
        autoStartOnBoot: false,
      ),
    );
  }

  void startBackgroundService() {
    final service = FlutterBackgroundService();
    service.startService();
  }

  void stopBackgroundService() {
    final service = FlutterBackgroundService();
    service.invoke("stop");
  }

  @pragma('vm:entry-point')
  Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    return true;
  }

  @pragma('vm:entry-point')
  void startTimer(ServiceInstance service) {
    _reportTimer?.cancel();
    _rankReportTimer?.cancel();
    _midnightTimer?.cancel();

    _reportTimer = Timer.periodic(const Duration(hours: 1), (_) {
      addWalkReport();
    });
    _rankReportTimer = Timer.periodic(const Duration(hours: 1), (_) {
      final DateTime dateTime = DateTime.now();
      if (_sendToTime == dateTime.second) {
        log("PedometerController: _rankReportTimer: _sendToTime: $_sendToTime, dateTime: $dateTime");
        addWalkReport();
      }
    });
    _midnightTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final DateTime dateTime = DateTime.now();
      if (dateTime.hour == 0 && dateTime.minute == 0 && dateTime.second == 0) {
        final DateTime now = DateTime.now();
        PrefsManager().setSteps(
          0,
          now.weekday == DateTime.sunday ? 0 : weeklyWalkCount,
          now.day == 1 ? 0 : monthlyWalkCount,
          totalWalkCount,
        );
        getWalkHitory();
        PrefsManager().setLastReportedSteps(0);
      }
    });
  }

  // 서버로부터 걸음 수 받아오기
  Future<void> getWalkHitory() async {
    final String requestURL = DotEnvManager().walkHistoryUrl;
    final (
      savedTodayWalkCount,
      savedWeeklyWalkCount,
      savedMonthlyWalkCount,
      savedTotalWalkCount
    ) = PrefsManager().getSteps();

    try {
      final http.Response response = await http.get(
        Uri.parse(requestURL),
        headers: {"Authorization": _authorization},
      );

      final String responseBody = response.body;
      final Map<String, dynamic> bodyToJson = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        if (savedTodayWalkCount >= bodyToJson['todayWalkCount']) {
          todayWalkCount = savedTodayWalkCount;
          weeklyWalkCount = savedWeeklyWalkCount;
          monthlyWalkCount = savedMonthlyWalkCount;
          totalWalkCount = savedTotalWalkCount;
        } else {
          todayWalkCount = bodyToJson['todayWalkCount'];
          weeklyWalkCount = bodyToJson['weeklyWalkCount'];
          monthlyWalkCount = bodyToJson['monthlyWalkCount'];
          totalWalkCount = bodyToJson['totalWalkCount'];
        }
        steps = todayWalkCount;

        // log("PedometerController : getWalkHistory : todayWalkCount : $todayWalkCount");
        // log("PedometerController : getWalkHistory : weeklyWalkCount : $weeklyWalkCount");
        // log("PedometerController : getWalkHistory : monthlyWalkCount : $monthlyWalkCount");
        // log("PedometerController : getWalkHistory : totalWalkCount : $totalWalkCount");
      } else {
        throw Exception();
      }
    } catch (e) {
      log(e.toString());
    }

    return;
  }

  void onStepCountFromNative(int steps) {
    if (_stepsAfterLastBoot == null) {
      _stepsAfterLastBoot = steps;
      totalSteps = steps;
      this.steps = 0;
    }

    final int oldSteps = totalSteps;
    totalSteps = steps;

    final int stepsDiff = totalSteps - oldSteps;
    if (stepsDiff > 0) {
      this.steps += stepsDiff;
      todayWalkCount += stepsDiff;
      weeklyWalkCount += stepsDiff;
      monthlyWalkCount += stepsDiff;
      totalWalkCount += stepsDiff;
    }
  }

  // 걸음 수가 변경될 때마다 호출되는 이벤트 핸들러
  void onStepCount(StepCount event) {
    // log("PedometerController : onStepCount : isInValidArea : $isInValidArea");

    if (!isInValidArea) return;

    // 부팅 이후 걸음 수가 null이라면 초기화
    if (_stepsAfterLastBoot == null) {
      _stepsAfterLastBoot = event.steps;
      totalSteps = event.steps;
      steps = 0;
    }

    // 이전 걸음 수를 저장하고, 앱 실행 이후 전체 걸음 수를 업데이트
    //
    final int oldSteps = totalSteps;
    totalSteps = event.steps;

    final int stepsDiff = totalSteps - oldSteps;

    if (stepsDiff > 0) {
      steps += stepsDiff;
      todayWalkCount += stepsDiff;
      weeklyWalkCount += stepsDiff;
      monthlyWalkCount += stepsDiff;
      totalWalkCount += stepsDiff;
    }
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    log('onPedestrianStatusChanged $event');
    status = event.status;
    PrefsManager().setSteps(
        todayWalkCount, weeklyWalkCount, monthlyWalkCount, totalWalkCount);
  }

  void onPedestrianStatusError(error) {
    log('onPedestrianStatusError: $error');
    status = 'Pedestrian Status not available';
    log(_status.toString());
  }

  void onStepCountError(error) {
    log('onStepCountError: $error');
  }
}
