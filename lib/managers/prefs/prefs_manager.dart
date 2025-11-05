import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class PrefsManager {
  static final PrefsManager _instance = PrefsManager._internal();
  static late final SharedPreferences _prefs;

  factory PrefsManager() => _instance;

  PrefsManager._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<SharedPreferences> _ensurePrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs;
  }

  bool containsKey(String key) {
    _ensurePrefs();
    return _prefs.containsKey(key);
  }

  void remove(String key) {
    _ensurePrefs();
    _prefs.remove(key);
  }

  Future<void> clear() async {
    _ensurePrefs();
    await _prefs.clear();
  }

  String getLastResetYmd() {
    _ensurePrefs();
    return _prefs.getString("lastResetYmd") ?? '';
  }

  Future<void> setLastResetYmd(String todayKey) async {
    _ensurePrefs();
    await _prefs.setString("lastResetYmd", todayKey);
  }

  String getLastResetYmdTest() {
    _ensurePrefs();
    return _prefs.getString("lastResetYmdTest") ?? '';
  }

  Future<void> setLastResetYmdTest(String todayKey) async {
    _ensurePrefs();
    await _prefs.setString("lastResetYmdTest", todayKey);
  }

  // 전송 못한 걸음 수 리스트 저장
  Future<void> setUnsentStepsList(List<Map<String, dynamic>> list) async {
    _ensurePrefs();
    await _prefs.setString("unsentStepsList", jsonEncode(list));
  }

  List<Map<String, dynamic>> getUnsentStepsList() {
    _ensurePrefs();
    final s = _prefs.getString('unsentStepsList');
    if (s == null || s.isEmpty) return <Map<String, dynamic>>[];

    try {
      final raw = jsonDecode(s); // dynamic
      if (raw is List) {
        return raw
            .map((e) => Map<String, dynamic>.from(e as Map)) // 핵심!
            .toList();
      }
    } catch (e) {
      log('PrefsManager.getUnsentStepsList parse error: $e');
    }
    return <Map<String, dynamic>>[];
  }

  Future<void> setLastReportedTime(DateTime dateTime) async {
    _ensurePrefs();
    await _prefs.setString("lastReportedTime", dateTime.toIso8601String());
  }

  DateTime getLastReportedTime() {
    _ensurePrefs();
    final s = _prefs.getString("lastReportedTime");
    if (s == null || s.isEmpty) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    } else {
      try {
        return DateTime.parse(s);
      } catch (e) {
        log('PrefsManager.getLastReportedTime parse error: $e');
        return DateTime.fromMillisecondsSinceEpoch(0);
      }
    }
  }

  Future<void> setLastReportedSteps(int steps) async {
    _ensurePrefs();
    await _prefs.setInt("lastReportedSteps", steps);
  }

  int getLastReportedSteps() {
    _ensurePrefs();
    return _prefs.getInt("lastReportedSteps") ?? 0;
  }

  (int, int, int, int) getSteps() {
    _ensurePrefs();
    final todayWalkCount = _prefs.getInt("todayWalkCount") ?? 0;
    final weeklyWalkCount = _prefs.getInt("weeklyWalkCount") ?? 0;
    final monthlyWalkCount = _prefs.getInt("monthlyWalkCount") ?? 0;
    final totalWalkCount = _prefs.getInt("totalWalkCount") ?? 0;
    return (todayWalkCount, weeklyWalkCount, monthlyWalkCount, totalWalkCount);
  }
  int getDeviceStepsLatest() {
    _ensurePrefs();
    return _prefs.getInt("deviceStepsLatest") ?? 0;
  }

  Future<void> setDeviceStepsLatest(int deviceStepsLatest) async {
    _ensurePrefs();
    await _prefs.setInt("deviceStepsLatest", deviceStepsLatest);
  }

  int getDeviceStepsLastHandled() {
    _ensurePrefs();
    return _prefs.getInt("deviceStepsLastHandled") ?? 0;
  }

  Future<void> setDeviceStepsLastHandled(int deviceStepsLastHandled) async {
    _ensurePrefs();
    await _prefs.setInt("deviceStepsLastHandled", deviceStepsLastHandled);
  }

  Future<void> setSteps(int todayWalkCount, int weeklyWalkCount, int monthlyWalkCount, int totalWalkCount) async {
    _ensurePrefs();
    await Future.wait([
      _prefs.setInt("todayWalkCount", todayWalkCount),
      _prefs.setInt("weeklyWalkCount", weeklyWalkCount),
      _prefs.setInt("monthlyWalkCount", monthlyWalkCount),
      _prefs.setInt("totalWalkCount", totalWalkCount),
    ]);
  }

  Future<void> removeStepsAfterLastboot() async {
    _ensurePrefs();
    await _prefs.remove("stepsAfterLastboot");
  }

  Future<void> setStepsAfterLastboot(int steps) async {
    _ensurePrefs();
    await _prefs.setInt("stepsAfterLastboot", steps);
  }

  int? getStepsAfterLastboot() {
    _ensurePrefs();
    return _prefs.getInt("stepsAfterLastboot");
  }

  bool isStudentIdSaved() {
    _ensurePrefs();
    return _prefs.containsKey("saved_studentId");
  }

  bool isPasswordSaved() {
    _ensurePrefs();
    return _prefs.containsKey("saved_password");
  }

  String getSavedStudentId() {
    _ensurePrefs();
    return _prefs.getString("saved_studentId") ?? '';
  }

  String getSavedPassword() {
    _ensurePrefs();
    return _prefs.getString("saved_password") ?? '';
  }

  Future<void> setSavedStudentId(String studentId) {
    _ensurePrefs();
    return _prefs.setString("saved_studentId", studentId);
  }

  Future<void> setSavedPassword(String password) {
    _ensurePrefs();
    return _prefs.setString("saved_password", password);
  }

  void resetSavedStudentIdAndPassword() {
    _ensurePrefs();
    _prefs.remove("saved_studentId");
    _prefs.remove("saved_password");
  }

  T getValueAs<T>(String key) {
    _ensurePrefs();
    if (!_prefs.containsKey(key)) return defaultValue<T>();

    switch (T) {
      case const (int):
        return _prefs.getInt(key) as T? ?? defaultValue<T>();
      case const (double):
        return _prefs.getDouble(key) as T? ?? defaultValue<T>();
      case const (String):
        return _prefs.getString(key) as T? ?? defaultValue<T>();
      default:
        throw Exception('Not supported type');
    }
  }

  Future<void> setValue<T>(String key, T value) async {
    _ensurePrefs();
    switch (T) {
      case const (int):
        await _prefs.setInt(key, value as int);
        break;
      case const (double):
        await _prefs.setDouble(key, value as double);
        break;
      case const (String):
        await _prefs.setString(key, value as String);
        break;
      default:
        throw Exception('Not supported type');
    }
  }

  T defaultValue<T>() {
    _ensurePrefs();
    switch (T) {
      case const (int):
        return 0 as T;
      case const (double):
        return 0.0 as T;
      case const (String):
        return '' as T;
      default:
        throw Exception('Not supported type');
    }
  }
}
