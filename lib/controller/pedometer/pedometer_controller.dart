import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:beat_flutter/controller/location/location_controller.dart';
import 'package:beat_flutter/managers/background_service/background_service_entry.dart';
import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/logger/beat_logger.dart';
import 'package:beat_flutter/managers/permission/permission_manager.dart';
import 'package:beat_flutter/managers/prefs/prefs_manager.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:pedometer/pedometer.dart';
import 'package:http/http.dart' as http;

class PedometerController extends GetxController {
  /// iOS 네이티브와 통신하기 위한 MethodChannel
  /// iOS의 모든 백그라운드 작업(걸음 수 동기화, 랭킹 집계, 자정 초기화)이 이 채널을 통해 이루어짐
  static const _channel = MethodChannel("com.beat.walkreport/pedometer");

  // 언어
  final LocalizationManager localizationManager = LocalizationManager();

  // 토큰
  String _authorization = '';

  String get authorization => _authorization;

  void setAuthorization(String authorization) {
    _authorization = authorization;
    // 로그인 성공 시점에 서버/저장값 복원
    getWalkHitory();
  }

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
  /// 객체가 생성될 때 초기화
  /// 서비스에서 요구하는 것은 부팅 이후 총 걸음 수가 아닌 앱 실행 이후 걸음 수이므로
  /// 최초 앱 실행 시점에 시스템에 기록된 부팅 이후 걸음 수가 몇 걸음이었는지를 기억하고
  /// 이후 걸음 수 이벤트에서 이 값과 갱신된 걸음 수의 차이를 계산함.
  /// 이 값은 매일 자정에만 초기화되며, 걸음 수는 일 단위로 측정되므로 내부 저장소에 저장될 필요가 있다.
  int? stepsAfterLastBoot;

  /// 걸음 수 이벤트 발생 시 걸음 수가 반드시 1씩 증가하는 것이 아님.
  /// 이 값은 직전 걸음 수 이벤트의 걸음 수를 기록하고, 걸음 수 이벤트 발생 시
  /// 이 값과 현재 걸음 수의 차만큼을 걸음 수에 더함.
  int? _previousSteps;

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

  /// 서버에 기록된, 서버에 기록될, 서버로부터 전달받은 총 걸음 수
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

  /// 오늘이 공휴일인지?
  final RxBool _isHoliday = true.obs;

  bool get isHoliday => _isHoliday.value;

  set isHoliday(bool value) => _isHoliday.value = value;

  /// 현재 위치가 유효 범위 내에 있는지?
  final RxBool _isInValidArea = false.obs;

  bool get isInValidArea => _isInValidArea.value;

  set isInValidArea(bool value) => _isInValidArea.value = value;

  /// 이벤트 진행 시간인지?
  final RxBool _isEventDuration = true.obs;

  bool get isEventDuration => _isEventDuration.value;

  set isEventDuration(bool value) => _isEventDuration.value = value;

  /// 오늘 최대 걸음 수에 도달했는지?
  final RxBool _isReachedMaxStepCount = false.obs;

  bool get isReachedMaxStepCount => _isReachedMaxStepCount.value;

  set isReachedMaxStepCount(bool value) => _isReachedMaxStepCount.value = value;

  /// [_reportTimer] : 1시간마다 서버와 걸음 수를 동기화
  Timer? _reportTimer;

  /// [_rankReportTimer] : 매 시 59분 특정 초에 서버에 걸음 수를 동기화
  Timer? _rankReportTimer;

  /// 생성자
  /// 걷기 상태, 걸음 수 스트림을 초기화하고
  /// 내부 저장소에 저장된 최종 보고 걸음 수를 읽어옴
  /// 내부 저장소에 저장된 보고하지 못한 걸음 수 리스트를 읽어옴
  /// [_walkReports]에 변화가 있을 때마다 이를 감지해 서버에 보고하도록 리스너 추가
  PedometerController() {
    // initPlatformState();

    // TODO: 만약 한 기기에서 어떤 사용자가 앱을 사용하다 로그아웃하고, 다른 사용자가 로그인한 경우
    // 내부 저장소에 저장된 lastReportedSteps, unsentStepsList가 이전 사용자의 것을 사용하게 됨
    // lastReportedSteps, unsentStepsList는 앱 내에서 측정된 "실제 걸음수"를 저장하기 때문에,
    // 두 사용자 모두에게 유효한 값이 아닐 수도 있음
    // _walkReports 리스너 또한 앱 실행 -> 컨트롤러 생성 -> 생성자에서 등록하기 때문에,
    // 위 문제를 해결하기 위해 리스너 등록 로직과 시점이 변경되어야 할 수 있음.
    _lastReportedTime = PrefsManager().getLastReportedTime();
    _lastReportedSteps = PrefsManager().getLastReportedSteps();
    stepsAfterLastBoot = PrefsManager().getStepsAfterLastboot();
    _walkReports.assignAll(PrefsManager().getUnsentStepsList());

    BEATLogger.d(
        "PedometerController created : _lastReportedTime: $_lastReportedTime, _lastReportedSteps: $_lastReportedSteps, _stepsAfterLastBoot: $stepsAfterLastBoot, _walkReports: $_walkReports");

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
            _walkReports.clear();
          } else {
            todayWalkCount = savedToday;
            weeklyWalkCount = savedWeekly;
            monthlyWalkCount = savedMonthly;
            totalWalkCount = savedTotal;
          }
        } catch (e) {
          BEATLogger.d("PedometerController : ever : ${e.toString()}");
        } finally {
          PrefsManager().setUnsentStepsList(reports);
        }
      },
    );
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

  void onPedestrianStatusChanged(PedestrianStatus event) {
    status = event.status;

    if (status == "stopped") {
      PrefsManager().setSteps(
        todayWalkCount,
        weeklyWalkCount,
        monthlyWalkCount,
        totalWalkCount,
      );
    }
  }

  void onPedestrianStatusError(error) {
    status = 'Pedestrian Status not available';
  }

  /// 포어그라운드 걸음 수 이벤트 처리
  /// 안드로이드 백그라운드 걸음 수 이벤트 처리
  /// _stepsAfterLastBoot가 null인 경우는 앱을 처음 실행한 경우.
  /// 이 경우 _stepsAfterLastBoot를 event.steps로 초기화
  /// _stepsAfterLastBoot가 null이 아니고, _stepsAfterLastBoot > event.steps인 경우는
  /// 기기가 재부팅된 경우.
  /// 이 경우 _stepsAfterLastBoot를 event.steps로 재초기화
  void onStepCount(StepCount event) {
    // 1) 베이스라인은 항상 갱신 (최초 실행 또는 재부팅 보정)
    if (stepsAfterLastBoot == null ||
        (stepsAfterLastBoot != null && stepsAfterLastBoot! > event.steps)) {
      stepsAfterLastBoot = event.steps;
      PrefsManager().setStepsAfterLastboot(stepsAfterLastBoot!);
    }

    // 2) 이전 디바이스 스텝을 항상 최신으로 유지
    if (_previousSteps == null ||
        (_previousSteps != null && _previousSteps! > event.steps)) {
      _previousSteps = event.steps;
    }

    int diff = event.steps - _previousSteps!;
    _previousSteps = event.steps; // 항상 따라감

    // 3) 합산은 조건 만족할 때만 (권한/시간/영역/휴일)
    if (PermissionManager.isActivityPermissionGrantedStatic == null ||
        !PermissionManager.isActivityPermissionGrantedStatic! ||
        !isEventDuration || !isInValidArea || isHoliday || diff <= 0) {
      return;
    }

    // steps += diff;
    todayWalkCount += diff;
    weeklyWalkCount += diff;
    monthlyWalkCount += diff;
    totalWalkCount += diff;
    // 증가 시점마다 즉시 영속화해 앱 재시작 시 초기화 방지
    PrefsManager().setSteps(
      todayWalkCount,
      weeklyWalkCount,
      monthlyWalkCount,
      totalWalkCount,
    );
  }

  /// iOS 백그라운드 걸음 수 이벤트 처리
  void onStepCountFromNative(int stepsFromNative) {
    // 1) 베이스라인은 항상 갱신
    if (stepsAfterLastBoot == null ||
        (stepsAfterLastBoot != null &&
            stepsAfterLastBoot! > stepsFromNative)) {
      stepsAfterLastBoot = stepsFromNative;
      PrefsManager().setStepsAfterLastboot(stepsAfterLastBoot!);
    }

    // 2) 이전 디바이스 스텝을 항상 최신으로 유지
    if (_previousSteps == null ||
        (_previousSteps != null && _previousSteps! > stepsFromNative)) {
      _previousSteps = stepsFromNative;
    }

    int diff = stepsFromNative - _previousSteps!;
    _previousSteps = stepsFromNative;

    // 3) 합산은 조건 만족할 때만
    if (PermissionManager.isActivityPermissionGrantedStatic == null ||
        !PermissionManager.isActivityPermissionGrantedStatic! ||
        !isEventDuration || !isInValidArea || isHoliday || diff <= 0) {
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
  }

  /// iOS 백그라운드 걸음 수 이벤트 처리
  void onPedestrianStatusChangedFromNative(String status) {
    if (status == "stopped") {
      PrefsManager().setSteps(
        todayWalkCount,
        weeklyWalkCount,
        monthlyWalkCount,
        totalWalkCount,
      );
    }
  }

  void onStepCountError(error) {
    BEATLogger.d('onStepCountError: $error');
  }

  /// 서버로부터 걸음 수를 읽어오는 메소드
  /// 내부 저장소에 저장된 오늘, 주간, 월간, 총 걸음 수와 비교해 더 큰 값을 사용
  /// 서버에 주기적으로 걸음 수를 보고하기 때문에, 서버에 걸음 수 보고 이후 다음 보고 이전까지의 걸음 수는 누락됨.
  /// 따라서 내부 저장소에 저장된 걸음 수가 서버로부터 전달받은 걸음 수보다 크다면 내부 저장소에 저장된 걸음 수를 사용
  Future<void> getWalkHitory() async {
    final String requestURL = DotEnvManager().walkHistoryUrl;

    try {
      final (savedToday, savedWeekly, savedMonthly, savedTotal) =
          PrefsManager().getSteps();

      BEATLogger.d(
          "PedometerController : getWalkHistory : savedToday: $savedToday, savedWeekly: $savedWeekly, savedMonthly: $savedMonthly, savedTotal: $savedTotal, _lastReportedSteps: $_lastReportedSteps");

      final response = await http.get(
        Uri.parse(requestURL),
        headers: {"Authorization": _authorization},
      );

      // BEATLogger.d(
      //     "PedometerController : getWalkHitory() response : $response");

      if (response.statusCode == 200) {
        BEATLogger.d(
            "PedometerControlelr : getWalkHistory : API request Success : response.body : ${response.body}");

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
      } else {
        todayWalkCount = savedToday;
        weeklyWalkCount = savedWeekly;
        monthlyWalkCount = savedMonthly;
        totalWalkCount = savedTotal;
        // steps = todayWalkCount;
        // totalSteps = totalWalkCount;
      }
      PrefsManager().setSteps(
          todayWalkCount, weeklyWalkCount, monthlyWalkCount, totalWalkCount);
      BEATLogger.d(
          "PedometerController : getWalkHistory : todayWalkCount: $todayWalkCount, weeklyWalkCount: $weeklyWalkCount, monthlyWalkCount: $monthlyWalkCount, totalWalkCount: $totalWalkCount, _lastReportedSteps: $_lastReportedSteps, _stepsAfterLastBoot: $stepsAfterLastBoot");
    } catch (e) {
      BEATLogger.d("PedometerController : getWalkHitory() : ${e.toString()}");
    }
  }

  /// [_walkReports]에 새 보고 항목 추가
  /// _lastReportedTime, _lastReportedSteps 갱신
  /// 내부 저장소에 걸음 수, _lastReportedTime, _lastReportedSteps 저장
  void addWalkReport() async {
    final DateTime now = DateTime.now();

    _walkReports.add({
      "historyDateTime":
          DateTime(now.year, now.month, now.day, now.hour + 1, 0, 0)
              .toIso8601String(),
      "walkCount": todayWalkCount - _lastReportedSteps,
    });

    BEATLogger.d(
        "PedometerController : addWalkReport() : _lastReportedSteps: $_lastReportedSteps, totalWalkCount: $totalWalkCount");
    BEATLogger.d(
        "PedometerController : addWalkReport() : historyDateTime: ${DateTime(now.year, now.month, now.day, now.hour + 1, 0, 0).toIso8601String()}, walkCount: ${totalWalkCount - _lastReportedSteps}");

    _lastReportedTime = now;
    _lastReportedSteps = totalWalkCount;

    PrefsManager().setSteps(
      todayWalkCount,
      weeklyWalkCount,
      monthlyWalkCount,
      totalWalkCount,
    );
    PrefsManager().setLastReportedTime(_lastReportedTime);
    PrefsManager().setLastReportedSteps(_lastReportedSteps);

    // TODO: 출시 때는 삭제해야됨
    BEATLogger.d(
        "PedometerController : addWalkReport() - ${_walkReports.toString()}");
    BEATLogger.d(
        "PedometerController : addWalkReport() - lastReportedTime: $_lastReportedTime, lastReportedSteps: $_lastReportedSteps");
    BEATLogger.d(
        "PedometerController : addWalkReport() - totalWalkCount: $totalWalkCount, todayWalkCount: $todayWalkCount, weeklyWalkCount: $weeklyWalkCount, monthlyWalkCount: $monthlyWalkCount, totalWalkCount: $totalWalkCount");
  }

  /// 백그라운드 서비스 초기화
  Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: startPedometerTimerForeground,
        onBackground: startPedometerTimerBackgroundIOS,
      ),
      androidConfiguration: AndroidConfiguration(
        autoStart: false,
        onStart: startPedometerTimerForeground,
        isForegroundMode: false,
        autoStartOnBoot: false,
      ),
    );
  }

  /// 1시간마다 서버와 걸음 수 동기화하는 타이머 시작
  void startReportTimer() async {
    _reportTimer = Timer.periodic(
      const Duration(hours: 1),
      // const Duration(minutes: 1),
      (_) async {
        await PermissionManager
            .ensureLocationAndActivityPermissionInitialized();
        if (!PermissionManager.isActivityPermissionGrantedStatic! ||
            !PermissionManager.isLocationPermissionGrantedStatic!) {
          return;
        }
        addWalkReport();
      },
    );
  }

  /// 매 시 59분 특정 초에 서버에 걸음 수 동기화하는 타이머 시작
  void startRankReportTimer() async {
    _rankReportTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) async {
        await PermissionManager
            .ensureLocationAndActivityPermissionInitialized();
        if (!PermissionManager.isActivityPermissionGrantedStatic! ||
            !PermissionManager.isLocationPermissionGrantedStatic!) {
          return;
        }
        final DateTime dateTime = DateTime.now();
        if (dateTime.minute == 59 && _sendToTime == dateTime.second) {
          // if (dateTime.second == _sendToTime) {
          addWalkReport();
        }
      },
    );
  }

  /// 포어그라운드 서비스 시작/중지
  void startForegroundService() async {
    BEATLogger.d("PedometerController : startForegroundService()");

    PermissionManager.updateLocationAndActivityPemission();

    if (Platform.isIOS) {
      setMethodCallHandler();
      await _channel.invokeMethod("stopActivityUpdates");
      _channel.invokeMethod("startActivityUpdates");

      await _channel.invokeMethod("stopPedometer");
      _channel.invokeMethod("startPedometer");
    } else {
      initPlatformState();
    }

    startReportTimer();
    startRankReportTimer();
    getWalkHitory();
  }

  Future<void> stopForegroundService() async {
    BEATLogger.d("PedometerController : stopForegroundService()");

    await PrefsManager().setSteps(
        todayWalkCount, weeklyWalkCount, monthlyWalkCount, totalWalkCount);

    if (stepsAfterLastBoot != null) {
      await PrefsManager().setStepsAfterLastboot(stepsAfterLastBoot!);
    }

    if (Platform.isIOS) {
      _channel.invokeMethod("stopPedometer");
      _channel.invokeMethod("stopActivityUpdates");
      _channel.setMethodCallHandler(null);
    }

    _reportTimer?.cancel();
    _rankReportTimer?.cancel();

    _reportTimer = null;
    _rankReportTimer = null;

    removeListeners();
  }

  /// 백그라운드 서비스 시작/중지
  void startBackgroundService() async {
    BEATLogger.d("PedometerController : startBackgroundService()");

    if (Platform.isIOS) {
      setMethodCallHandler();
      await _channel.invokeMethod("stopActivityUpdates");
      _channel.invokeMethod("startActivityUpdates");

      await _channel.invokeMethod("stopPedometer");
      _channel.invokeMethod("startPedometer");
    } else {
      initPlatformState();

      startReportTimer();
      startRankReportTimer();
      getWalkHitory();
    }


    FlutterBackgroundService().startService();
  }

  Future<void> stopBackgroundService() async {
    BEATLogger.d("PedometerController : stopBackgroundService()");
    FlutterBackgroundService().invoke("stopService");

    await PrefsManager().setSteps(
        todayWalkCount, weeklyWalkCount, monthlyWalkCount, totalWalkCount);
    if (stepsAfterLastBoot != null) {
      await PrefsManager().setStepsAfterLastboot(stepsAfterLastBoot!);
    }

    if (Platform.isIOS) {
      _channel.invokeMethod("stopPedometer");
      _channel.invokeMethod("stopActivityUpdates");
      _channel.setMethodCallHandler(null);
    }

    _reportTimer?.cancel();
    _rankReportTimer?.cancel();

    _reportTimer = null;
    _rankReportTimer = null;
  }

  /// iOS 네이티브에서 걸음 수 업데이트 요청을 처리하는 핸들러 설정
  void setMethodCallHandler() {
    if (Platform.isIOS) {
      _channel.setMethodCallHandler(
        (call) async {
          switch (call.method) {
            case "updateStepsFromNative":
              final steps = call.arguments["steps"] as int;
              onStepCountFromNative(steps);
              break;
            case "updatePedestrianStatus":
              final status = call.arguments["status"] as String;
              onPedestrianStatusChangedFromNative(status);
              break;
          }
        },
      );
    }
  }

  /// 자정 초기화 메소드
  /// 오늘 걸음 수를 0으로 초기화
  /// 오늘이 일요일이면 주간 걸음 수를 0으로 초기화, 아니면 유지
  /// 오늘이 1일이면 월간 걸음 수를 0으로 초기화, 아니면 유지
  /// 총 걸음 수는 유지
  /// 초기화된 걸음 수들을 내부 저장소에 저장
  /// _lastReportedSteps를 0으로 초기화(오늘 걸음 수가 0으로 초기화되었고, 오늘 서버에 걸음 수를 보고한 적이 없으므로)
  /// 0으로 초기화된 _lastReportedSteps를 내부 저장소에 저장
  /// 이 메소드는 [LocationController]에서 자정이 되었음을 감지했을 때 간접적으로 호출된다.
  /// 메소드 채널 핸들러는 각 메소드에 대해 한 번씩만 등록이 가능하기 때문.
  /// iOS 네이티브에서 자정이 되었음을 감지 -> 메소드 채널로 자정 초기화 이벤트 전송 -> 이를 [LocationManager]에서 감지 -> 자정 초기화를 진행한다.
  ///
  /// 최하단의 [initPlatformState]는 현재는 필요없지만, 추후 일간 최대 걸음 수를 설정한다면 주석 해제해주어야 한다.
  /// 일간 최대 걸음 수 달성 시 걸음 상태, 걸음 수 리스너가 해제되기 때문에, 이 메소드가 호출되는 시점에 리스너가 해제되어있을 수 있기 때문이다.
  /// 리스너가 해제되어있다면 다시 설정해주어야 한다.
  void resetAtMidnight(DateTime dateTime) {
    BEATLogger.d("PedometerController : resetAtMidnight()");
    final DateTime now = DateTime.now();

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

    _lastReportedSteps = 0;
    PrefsManager().setLastReportedSteps(0);

    BEATLogger.d(
        "PedometerController : 초기화 전 값들 - today: $todayWalkCount, weekly: $weeklyWalkCount, monthly: $monthlyWalkCount, total: $totalWalkCount, _lastReportedSteps: $_lastReportedSteps");
    BEATLogger.d(
        "PedometerController : 초기화 후 값들 - today: $saveSteps, weekly: $saveWeeklyWalkCount, monthly: $saveMonthlyWalkCount, total: $saveTotalWalkCount, _lastReportedSteps: $_lastReportedSteps");

    // addWalkReport();
  }

  /// 걸음 상태, 걸음 수 리스너 해제
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

    _stepCountSubscription = null;
    _pedestrianStatusSubscription = null;

    super.dispose();
  }

// @pragma('vm:entry-point')
// void startTimer(ServiceInstance service) async {
//   await EasyLocalization.ensureInitialized();
//
//   _reportTimer?.cancel();
//   _rankReportTimer?.cancel();
//
//   // iOS에서는 네이티브에서 정확한 시간에 작업을 수행하므로 타이머 사용하지 않음
//   if (Platform.isIOS) {
//     BEATLogger.d("PedometerController : iOS에서는 네이티브 스케줄링 시스템 사용");
//   } else {
//     // Android에서는 기존 타이머 방식 사용
//     _reportTimer = Timer.periodic(
//       const Duration(hours: 1),
//       (_) async {
//         if (!PermissionManager.isActivityPermissionGrantedStatic ||
//             !PermissionManager.isLocationPermissionGrantedStatic) {
//           return;
//         }
//         addWalkReport();
//       },
//     );
//
//     _rankReportTimer = Timer.periodic(
//       const Duration(seconds: 1),
//       (_) async {
//         if (!PermissionManager.isActivityPermissionGrantedStatic ||
//             !PermissionManager.isLocationPermissionGrantedStatic) {
//           return;
//         }
//         final DateTime dateTime = DateTime.now();
//         if (dateTime.minute == 59 && _sendToTime == dateTime.second) {
//           addWalkReport();
//         }
//       },
//     );
//   }
// }
}
