import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:beat_flutter/controller/location/location_controller.dart';
import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/logger/beat_logger.dart';
import 'package:beat_flutter/managers/permission/permission_manager.dart';
import 'package:beat_flutter/managers/prefs/prefs_manager.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
    // getWalkHitory();
  }

  // 랭킹 집계 서버 전송 시각
  int _sendToTime = 0;

  int get sendToTime => _sendToTime;

  void setSendToTime(int value) => _sendToTime = value;

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

  /// 오늘 최대 걸음 수에 도달했는지?
  final RxBool _isReachedMaxStepCount = false.obs;

  bool get isReachedMaxStepCount => _isReachedMaxStepCount.value;

  set isReachedMaxStepCount(bool value) => _isReachedMaxStepCount.value = value;

  /// 생성자
  /// 걷기 상태, 걸음 수 스트림을 초기화하고
  /// 내부 저장소에 저장된 최종 보고 걸음 수를 읽어옴
  /// 내부 저장소에 저장된 보고하지 못한 걸음 수 리스트를 읽어옴
  /// [_walkReports]에 변화가 있을 때마다 이를 감지해 서버에 보고하도록 리스너 추가
  PedometerController() {
    // initPlatformState();

    if (Platform.isIOS) {
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

      ever<List<Map<String, dynamic>>>(
        _walkReports,
        (reports) async {
          if (reports.isEmpty) return;

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
              if (_lastReportedTime.day != DateTime.now().day) {
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
              _lastReportedSteps = bodyToJson['todayWalkCount'];
            } else {
              if (_lastReportedTime.day != DateTime.now().day) {
                resetAtMidnight();
              } else {
                todayWalkCount = savedToday;
                weeklyWalkCount = savedWeekly;
                monthlyWalkCount = savedMonthly;
                totalWalkCount = savedTotal;
                _lastReportedSteps = savedToday;
              }
            }
          } catch (e) {
            BEATLogger.d("PedometerController : ever : ${e.toString()}");
          } finally {
            _walkReports.clear();
            PrefsManager().setUnsentStepsList(reports);
            BEATLogger.d(
                "PedometerController : ever : unsentStepsList : ${PrefsManager().getUnsentStepsList().toString()}");
          }
        },
      );
    }
  }

  // TODO: updateUISteps로 대체됨
  // void onStepCountFromAndroidBackground(int stepsFromBackground) {
  //   todayWalkCount += stepsFromBackground;
  //   weeklyWalkCount += stepsFromBackground;
  //   monthlyWalkCount += stepsFromBackground;
  //   totalWalkCount += stepsFromBackground;
  // }

  /// 백그라운드 걸음 수 이벤트 처리
  void onStepCountFromNative(int stepsFromNative) {
    // iOS: 자정 보정 가드
    ensureDailyResetGuard();
    // 1) 베이스라인은 항상 갱신
    if (stepsAfterLastBoot == null ||
        (stepsAfterLastBoot != null && stepsAfterLastBoot! > stepsFromNative)) {
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
    if (PermissionManager.isActivityPermissionGrantedStatic != true ||
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
  }

  /// 백그라운드 걸음 수 이벤트 처리
  void onPedestrianStatusChangedFromNative(String status) {
    // iOS: 자정 보정 가드
    ensureDailyResetGuard();
    if (status == "stopped") {
      PrefsManager().setSteps(
        todayWalkCount,
        weeklyWalkCount,
        monthlyWalkCount,
        totalWalkCount,
      );
    }
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
          "PedometerController : getWalkHistory : savedToday : $savedToday, savedWeekly : $savedWeekly, savedMonthly : $savedMonthly, savedTotal : $savedTotal");

      final lastReportedSteps = PrefsManager().getLastReportedSteps();

      final response = await http.get(
        Uri.parse(requestURL),
        headers: {"Authorization": _authorization},
      );

      if (response.statusCode == 200) {
        BEATLogger.d(
            "PedometerController : getWalkHistory : API request Success : response.body : ${response.body}");

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
        _lastReportedSteps = bodyToJson['todayWalkCount'];
      } else {
        todayWalkCount = savedToday;
        weeklyWalkCount = savedWeekly;
        monthlyWalkCount = savedMonthly;
        totalWalkCount = savedTotal;
        _lastReportedSteps = lastReportedSteps;
      }
      PrefsManager().setSteps(
          todayWalkCount, weeklyWalkCount, monthlyWalkCount, totalWalkCount);
      BEATLogger.d(
          "PedometerController : getWalkHistory : todayWalkCount: $todayWalkCount, weeklyWalkCount: $weeklyWalkCount, monthlyWalkCount: $monthlyWalkCount, totalWalkCount: $totalWalkCount, _lastReportedSteps: $_lastReportedSteps, _stepsAfterLastBoot: ${stepsAfterLastBoot.toString()}");
    } catch (e) {
      BEATLogger.d("PedometerController : getWalkHitory() : ${e.toString()}");
    }
  }

  /// [_walkReports]에 새 보고 항목 추가
  /// _lastReportedTime, _lastReportedSteps 갱신
  /// 내부 저장소에 걸음 수, _lastReportedTime, _lastReportedSteps 저장
  void addWalkReport() async {
    final DateTime now = DateTime.now();
    final int reportStep = max(0, todayWalkCount - _lastReportedSteps);

    _walkReports.add({
      "historyDateTime":
          DateTime(now.year, now.month, now.day, now.hour + 1, 0, 0)
              .toIso8601String(),
      "walkCount": reportStep,
    });

    _lastReportedTime = now;
    _lastReportedSteps = todayWalkCount;

    PrefsManager().setSteps(
      todayWalkCount,
      weeklyWalkCount,
      monthlyWalkCount,
      totalWalkCount,
    );
    PrefsManager().setLastReportedTime(_lastReportedTime);
    PrefsManager().setLastReportedSteps(_lastReportedSteps);
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
  void resetAtMidnight() {
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

    // 마지막 초기화 일자 저장 (YYYY-MM-DD)
    final String todayKey = DateFormat('yyyy-MM-dd').format(now);
    PrefsManager().setLastResetYmd(todayKey);

    // final (savedSteps, savedWeekly, savedMonthly, savedTotal) =
    //     PrefsManager().getSteps();
    // final int savedLastReportedSteps = PrefsManager().getLastReportedSteps();
    // BEATLogger.d(
    //     "PedometerController : resetAtMidnight : savedStepd : $savedSteps, savedWeekly : $savedWeekly, savedMonthly : $savedMonthly, savedTotal : $savedTotal, savedLastReportedSteps : $savedLastReportedSteps");
  }

  /// iOS에서 자정 초기화 누락 방지를 위한 가드
  /// 저장된 마지막 초기화 일자와 오늘 날짜가 다르면 즉시 자정 초기화 수행
  void ensureDailyResetGuard() {
    try {
      final String lastYmd = PrefsManager().getLastResetYmd();
      final String todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
      if (lastYmd != todayKey) {
        BEATLogger.d(
            "PedometerController : ensureDailyResetGuard() : lastYmd=$lastYmd, today=$todayKey -> reset");
        resetAtMidnight();
      }
    } catch (e) {
      BEATLogger.d(
          "PedometerController : ensureDailyResetGuard() error : ${e.toString()}");
    }
  }
}
