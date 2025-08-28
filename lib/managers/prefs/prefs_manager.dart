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

  // int? todaysBaseLine() {
  //   return _prefs.getInt("todaysBaseLine");
  // }
  //
  // Future<void> setTodaysBaseLine(int? steps) {
  //   if (steps == null) {
  //     return _prefs.remove("todaysBaseLine");
  //   } else {
  //     return _prefs.setInt("todaysBaseLine", steps);
  //   }
  // }
  //
  // int getSteps() {
  //   return _prefs.getInt("steps") ?? 0;
  // }
  //
  // Future<void> setSteps(int steps) {
  //   return _prefs.setInt("steps", steps);
  // }
  //
  // int getTotalSteps() {
  //   return _prefs.getInt("totalSteps") ?? 0;
  // }
  //
  // Future<void> setTotlaSteps(int steps) {
  //   return _prefs.setInt("totalSteps", steps);
  // }

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
