import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:beat_flutter/managers/background_service/background_service_entry.dart';
import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/logger/beat_logger.dart';
import 'package:beat_flutter/managers/notification/local_notification.dart';
import 'package:beat_flutter/managers/prefs/prefs_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:pedometer/pedometer.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class PedometerController extends GetxController {
  // iOS 네이티브와 통신하기 위한 MethodChannel
  // 모든 백그라운드 작업(걸음 수 동기화, 랭킹 집계, 자정 초기화)이 이 채널을 통해 이루어짐
  static const _channel = MethodChannel("com.beat.walkreport/channel");

  // 언어
  final LocalizationManager localizationManager = LocalizationManager();

  // 토큰
  String _authorization = '';

  String get authorization => _authorization;

  void setAuthorization(String authorization) => _authorization = authorization;

  // 랭킹 집계 서버 전송 시각
  int _sendToTime = 0;

  int get sendToTime => _sendToTime;

  void setSendToTime(int value) => _sendToTime = value;

  // 걸음 이벤트
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;

  StreamSubscription<StepCount>? _stepCountSubscription;
  StreamSubscription<PedestrianStatus>? _pedestrianStatusSubscription;

  // 상태
  final Rx<String> _status = ''.obs;

  String get status => _status.value;

  set status(String value) => _status.value = value;

  /// 일일 최대 걸음 수
  final int maxDailySteps = 20000;

  /// 부팅 이후 걸음 수
  int? _stepsAfterLastBoot;
  final Rx<int> _totalSteps = 0.obs;

  int get totalSteps => _totalSteps.value;

  set totalSteps(int value) => _totalSteps.value = value;

  /// 실제 앱에서 측정한 걸음 수
  final Rx<int> _steps = 0.obs;

  int get steps => _steps.value;

  set steps(int value) => _steps.value = value;

  /// 서버에 기록된, 서버로부터 전달받은 오늘 걸음 수
  final RxInt _todayWalkCount = 0.obs;

  int get todayWalkCount => _todayWalkCount.value;

  set todayWalkCount(int value) => _todayWalkCount.value = value;

  /// 서버에 기록된, 서버로부터 전달받은 주간 걸음 수
  final RxInt _weeklyWalkCount = 0.obs;

  int get weeklyWalkCount => _weeklyWalkCount.value;

  set weeklyWalkCount(int value) => _weeklyWalkCount.value = value;

  /// 서버에 기록된, 서버로부터 전달받은 월간 걸음 수
  final RxInt _monthlyWalkCount = 0.obs;

  int get monthlyWalkCount => _monthlyWalkCount.value;

  set monthlyWalkCount(int value) => _monthlyWalkCount.value = value;

  /// 서버에 기록된, 서버로부터 전달받은 총 걸음 수
  final RxInt _totalWalkCount = 0.obs;

  int get totalWalkCount => _totalWalkCount.value;

  set totalWalkCount(int value) => _totalWalkCount.value = value;

  /// 지난 번 서버에 보고한 걸음 수
  DateTime _lastReportedTime = DateTime.now();
  int _lastReportedSteps = 0;

  /// 서버로 걸음 수를 보고할 때 사용하는 큐.
  /// 서버로 걸음 수를 보고하려고 할 때마다 큐에 아이템을 추가하고 아이템이 추가될 때마다 이를 감지해 보고.
  /// 모종의 사유로 서버로 걸음 수를 전송할 수 없었다면 내부 저장소에 보관, 이후 한 번에 전송
  final RxList<Map<String, dynamic>> _walkReports =
      <Map<String, dynamic>>[].obs;

  final RxBool isActivityPermissionDenied = true.obs;
  final RxBool isLocationPermissionDenied = true.obs;
  final RxBool isHoliday = true.obs;

  /// 현재 위치가 유효 범위 내에 있는지?
  final RxBool isInValidArea = false.obs;

  /// [isEventDuration] : 이벤트 진행 시간 측정용 플래그
  final RxBool isEventDuration = true.obs;

  /// [_reportTimer] : 1시간마다 서버와 걸음 수를 동기화
  Timer? _reportTimer;

  /// [_rankReportTimer] : 매 시 59분 특정 초에 서버에 걸음 수를 동기화
  Timer? _rankReportTimer;

  bool get isReachedTodaysMaxStepCount => steps >= maxDailySteps ? true : false;

  void onStepCount(StepCount event) {
    if (isActivityPermissionDenied.value) return;
    if (!isEventDuration.value || !isInValidArea.value || isHoliday.value) return;

    if (_stepsAfterLastBoot == 0 ||
        (_stepsAfterLastBoot != null && _stepsAfterLastBoot! > event.steps)) {
      _stepsAfterLastBoot = event.steps;
      totalSteps = event.steps;
      log("PedometerController : _stepsAfterLastBoot - ${_stepsAfterLastBoot}");
      // steps = 0;
      PrefsManager().setStepsAfterLastboot(_stepsAfterLastBoot!);
    }

    final int oldSteps = totalSteps;
    totalSteps = event.steps;
    int diff = totalSteps - oldSteps;

    if (diff > 0) {
      if (steps + diff > maxDailySteps) {
        diff = diff - (steps + diff - maxDailySteps);
        steps = maxDailySteps;
        todayWalkCount += diff;
        weeklyWalkCount += diff;
        monthlyWalkCount += diff;
        totalWalkCount += diff;

        LocalNotificationManager.showNotification(
          localizationManager.lnReachedTodaysMaxStepCount,
          localizationManager.lnOutOfRangeBody,
        );

        removeListeners();
      } else {
        steps += diff;
        todayWalkCount += diff;
        weeklyWalkCount += diff;
        monthlyWalkCount += diff;
        totalWalkCount += diff;
      }
    }
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    status = event.status;

    PrefsManager().setSteps(
      todayWalkCount,
      weeklyWalkCount,
      monthlyWalkCount,
      totalWalkCount,
    );
  }

  void onPedestrianStatusError(error) {
    status = 'Pedestrian Status not available';
  }

  void onStepCountError(error) {
    log('onStepCountError: $error');
  }

  void onStepCountFromNative(int stepsFromNative) {
    if (isActivityPermissionDenied.value) return;
    if (!isEventDuration.value || !isInValidArea.value || isHoliday.value) return;

    if (_stepsAfterLastBoot == 0 ||
        (_stepsAfterLastBoot != null && _stepsAfterLastBoot! > stepsFromNative)) {
      _stepsAfterLastBoot = stepsFromNative;
      totalSteps = stepsFromNative;
      // steps = 0;
      log("PedometerController : _stepsAfterLastBoot - ${_stepsAfterLastBoot}");
      PrefsManager().setStepsAfterLastboot(_stepsAfterLastBoot!);
    }

    final int oldSteps = totalSteps;
    totalSteps = stepsFromNative;
    int diff = totalSteps - oldSteps;

    if (diff > 0) {
      if (steps + diff > maxDailySteps) {
        diff = diff - (steps + diff - maxDailySteps);
        steps = maxDailySteps;
        todayWalkCount += diff;
        weeklyWalkCount += diff;
        monthlyWalkCount += diff;
        totalWalkCount += diff;

        removeListeners();
      } else {
        steps += diff;
        todayWalkCount += diff;
        weeklyWalkCount += diff;
        monthlyWalkCount += diff;
        totalWalkCount += diff;
      }
    }
  }

  void setMethodCallHandler() {
    if (Platform.isIOS) {
      _channel.setMethodCallHandler(
        (call) async {
          switch (call.method) {
            case "updateStepsFromNative":
              final steps = call.arguments["steps"] as int;
              final pedometer = Get.find<PedometerController>();
              pedometer.onStepCountFromNative(steps);
          }
        },
      );
    }
  }

  /// 걷기 상태, 걸음 수 스트림 초기화
  Future<void> initPlatformState() async {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusSubscription = (_pedestrianStatusStream
        .listen(onPedestrianStatusChanged))
      ..onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountSubscription = _stepCountStream.listen(onStepCount)
      ..onError(onStepCountError);
  }

  /// 생성자
  /// 걷기 상태, 걸음 수 스트림을 초기화하고
  /// 내부 저장소에 저장된 최종 보고 걸음 수를 읽어옴
  /// 내부 저장소에 저장된 보고하지 못한 걸음 수 리스트를 읽어옴
  /// [_walkReports]에 변화가 있을 때마다 이를 감지해 서버에 보고하도록 리스너 추가
  PedometerController() {
    initPlatformState();
    
    // 권한 상태 초기화
    // _initializePermissionStatus();

    // PrefsManager().setLastReportedSteps(0);
    // getWalkHitory();
    _lastReportedTime = PrefsManager().getLastReportedTime();
    _lastReportedSteps = PrefsManager().getLastReportedSteps();
    _stepsAfterLastBoot = PrefsManager().getStepsAfterLastboot();
    _walkReports.assignAll(PrefsManager().getUnsentStepsList());

    ever<List<Map<String, dynamic>>>(
      _walkReports,
      (reports) async {
        if (reports.isEmpty) return;

        BEATLogger.d(
            "PedometerController : ever : _walkReports : $_walkReports");

        final String requestUrl = DotEnvManager().walkRecordUrl;
        final (savedToday, savedWeekly, savedMonthly, savedTotal) =
            PrefsManager().getSteps();

        try {
          final http.Response response = await http.post(
            Uri.parse(requestUrl),
            headers: {
              "Authorization": _authorization,
              "Content-Type": "application/json",
            },
            body: jsonEncode(_walkReports),
          );

          if (response.statusCode == 200) {
            final bodyToJson = jsonDecode(response.body);
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
            steps = todayWalkCount;
            _walkReports.clear();
          } else {
            throw Exception();
          }
        } catch (e) {
          log("PedometerController : ever : ${e.toString()}");
        } finally {
          PrefsManager().setUnsentStepsList(reports);
        }
      },
    );
  }

  /// 서버로부터 걸음 수를 읽어옴
  /// 내부 저장소에 저장된 오늘, 주간, 월간, 총 걸음 수와 비교해 더 큰 값을 사용
  /// 서버에 주기적으로 걸음 수를 보고하기 때문에, 서버에 걸음 수 보고 이후 다음 보고 이전까지의 걸음 수는 누락됨.
  /// 따라서 내부 저장소에 저장된 걸음 수가 서버로부터 전달받은 걸음 수보다 크다면 내부 저장소에 저장된 걸음 수를 사용
  Future<void> getWalkHitory() async {
    final String requestURL = DotEnvManager().walkHistoryUrl;
    final (savedToday, savedWeekly, savedMonthly, savedTotal) =
        PrefsManager().getSteps();

    try {
      final response = await http.get(
        Uri.parse(requestURL),
        headers: {"Authorization": _authorization},
      );

      // BEATLogger.d(
      //     "PedometerController : getWalkHitory() response : $response");

      if (response.statusCode == 200) {
        final bodyToJson = jsonDecode(response.body);
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
        steps = todayWalkCount;
      } else {
        throw Exception();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  /// [_walkReports]에 새 보고 항목 추가
  /// _lastReportedSteps 갱신
  /// 내부 저장소에 _lastReportedSteps 저장
  void addWalkReport() async {
    final DateTime now = DateTime.now();

    _walkReports.add({
      "historyDateTime":
          DateTime(now.year, now.month, now.day, now.hour + 1, 0, 0)
              .toIso8601String(),
      "walkCount": steps - _lastReportedSteps,
    });

    _lastReportedTime = now;
    _lastReportedSteps = steps;

    PrefsManager().setSteps(
      todayWalkCount,
      weeklyWalkCount,
      monthlyWalkCount,
      totalWalkCount,
    );
    PrefsManager().setLastReportedTime(_lastReportedTime);
    PrefsManager().setLastReportedSteps(_lastReportedSteps);

    // TODO: 출시 때는 삭제해야됨
    BEATLogger.d("PedometerController : addWalkReport() - ${_walkReports.toString()}");
    BEATLogger.d("PedometerController : addWalkReport() - lastReportedTime: $_lastReportedTime");
    BEATLogger.d("PedometerController : addWalkReport() - lastReportedSteps: $_lastReportedSteps");
    BEATLogger.d("PedometerController : addWalkReport() - todayWalkCount: $todayWalkCount");
    BEATLogger.d("PedometerController : addWalkReport() - weeklyWalkCount: $weeklyWalkCount");
    BEATLogger.d("PedometerController : addWalkReport() - monthlyWalkCount: $monthlyWalkCount");
    BEATLogger.d("PedometerController : addWalkReport() - totalWalkCount: $totalWalkCount");
  }

  /// 백그라운드 서비스 초기화
  Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: pedometerServiceStart, // ✅ top-level 함수
        onBackground: pedometerServiceIosBackground, // ✅ top-level 함수
      ),
      androidConfiguration: AndroidConfiguration(
        autoStart: false,
        onStart: pedometerServiceStart, // ✅ top-level 함수
        isForegroundMode: false,
        autoStartOnBoot: false,
      ),
    );
  }

  @pragma('vm:entry-point')
  void startTimer(ServiceInstance service) async {
    await EasyLocalization.ensureInitialized();

    _reportTimer?.cancel();
    _rankReportTimer?.cancel();

    // iOS에서는 네이티브에서 정확한 시간에 작업을 수행하므로 타이머 사용하지 않음
    if (Platform.isIOS) {
      BEATLogger.d("PedometerController : iOS에서는 네이티브 스케줄링 시스템 사용");
    } else {
      // Android에서는 기존 타이머 방식 사용
      _reportTimer = Timer.periodic(
        const Duration(hours: 1),
        (_) async {
          if (isActivityPermissionDenied.value || isLocationPermissionDenied.value) {
            return;
          }
          addWalkReport();
        },
      );

      _rankReportTimer = Timer.periodic(
        const Duration(seconds: 1),
        (_) async {
          if (isActivityPermissionDenied.value || isLocationPermissionDenied.value) {
            return;
          }
          final DateTime dateTime = DateTime.now();
          if (dateTime.minute == 59 && _sendToTime == dateTime.second) {
            addWalkReport();
          }
        },
      );
    }
  }

  void startBackgroundService() {
    BEATLogger.d("PedometerController : startBackgroundService()");
    FlutterBackgroundService().startService();
    setMethodCallHandler();
  }

  void stopBackgroundService() {
    BEATLogger.d("PedometerController : stopBackgroundService()");
    FlutterBackgroundService().invoke("stopService");

    _channel.setMethodCallHandler(null);

    _reportTimer?.cancel();
    _rankReportTimer?.cancel();

    _reportTimer = null;
    _rankReportTimer = null;
  }

  void resetAtMidnight(DateTime dateTime) {
    BEATLogger.d("PedometerController : resetAtMidnight() 시작");
    final DateTime now = DateTime.now();

    const int saveSteps = 0;
    final int saveWeeklyWalkCount =
        now.weekday == DateTime.sunday ? 0 : weeklyWalkCount;
    final int saveMonthlyWalkCount = now.day == 1 ? 0 : monthlyWalkCount;
    final int saveTotalWalkCount = totalWalkCount;

    BEATLogger.d(
        "PedometerController : 초기화 전 값들 - today: $todayWalkCount, weekly: $weeklyWalkCount, monthly: $monthlyWalkCount, total: $totalWalkCount");
    BEATLogger.d(
        "PedometerController : 초기화 후 값들 - today: $saveSteps, weekly: $saveWeeklyWalkCount, monthly: $saveMonthlyWalkCount, total: $saveTotalWalkCount");

    steps = saveSteps;
    todayWalkCount = saveSteps;
    weeklyWalkCount = saveWeeklyWalkCount;
    monthlyWalkCount = saveMonthlyWalkCount;

    PrefsManager().setSteps(
      saveSteps,
      saveWeeklyWalkCount,
      saveMonthlyWalkCount,
      saveTotalWalkCount,
    );

    _lastReportedSteps = 0;
    PrefsManager().setLastReportedSteps(0);

    BEATLogger.d("PedometerController : 자정 초기화 완료 - 모든 걸음 수 데이터 초기화됨");

    // removeListeners();
    // initPlatformState();
  }

  void removeListeners() {
    _stepCountSubscription?.cancel();
    _pedestrianStatusSubscription?.cancel();

    _stepCountSubscription = null;
    _pedestrianStatusSubscription = null;
  }

  @override
  dispose() {
    _reportTimer?.cancel();
    _rankReportTimer?.cancel();

    _reportTimer = null;
    _rankReportTimer = null;

    _stepCountSubscription?.cancel();
    _pedestrianStatusSubscription?.cancel();

    super.dispose();
  }
}
