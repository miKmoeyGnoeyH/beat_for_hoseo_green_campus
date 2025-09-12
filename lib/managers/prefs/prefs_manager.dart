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

  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  void remove(String key) {
    _prefs.remove(key);
  }

  // 전송 못한 걸음 수 리스트 저장
  Future<void> setUnsentStepsList(List<Map<String, dynamic>> list) {
    return _prefs.setString("unsentStepsList", jsonEncode(list));
  }

  List<Map<String, dynamic>> getUnsentStepsList() {
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

  Future<void> setLastReportedSteps(int steps) {
    return _prefs.setInt("lastReportedSteps", steps);
  }

  int getLastReportedSteps() {
    return _prefs.getInt("lastReportedSteps") ?? 0;
  }

  (int, int, int, int) getSteps() {
    final todayWalkCount = _prefs.getInt("todayWalkCount") ?? 0;
    final weeklyWalkCount = _prefs.getInt("weeklyWalkCount") ?? 0;
    final monthlyWalkCount = _prefs.getInt("monthlyWalkCount") ?? 0;
    final totalWalkCount = _prefs.getInt("totalWalkCount") ?? 0;
    return (todayWalkCount, weeklyWalkCount, monthlyWalkCount, totalWalkCount);
  }

  Future<void> setSteps(int todayWalkCount, int weeklyWalkCount, int monthlyWalkCount, int totalWalkCount) {
    _prefs.setInt("todayWalkCount", todayWalkCount);
    _prefs.setInt("weeklyWalkCount", weeklyWalkCount);
    _prefs.setInt("monthlyWalkCount", monthlyWalkCount);
    return _prefs.setInt("totalWalkCount", totalWalkCount);
  }

  bool isStudentIdSaved() {
    return _prefs.containsKey("saved_studentId");
  }

  bool isPasswordSaved() {
    return _prefs.containsKey("saved_password");
  }

  String getSavedStudentId() {
    return _prefs.getString("saved_studentId") ?? '';
  }

  String getSavedPassword() {
    return _prefs.getString("saved_password") ?? '';
  }

  Future<void> setSavedStudentId(String studentId) {
    return _prefs.setString("saved_studentId", studentId);
  }

  Future<void> setSavedPassword(String password) {
    return _prefs.setString("saved_password", password);
  }

  void resetSavedStudentIdAndPassword() {
    _prefs.remove("saved_studentId");
    _prefs.remove("saved_password");
  }

  T getValueAs<T>(String key) {
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
