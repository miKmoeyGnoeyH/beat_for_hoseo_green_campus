
import 'package:shared_preferences/shared_preferences.dart';

class PrefsManager {
  static final PrefsManager _instance = PrefsManager._internal();
  static late final SharedPreferences _prefs;

  factory PrefsManager() => _instance;
  PrefsManager._internal();

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static T getValueAs<T>(String key) {
    if (!_prefs.containsKey(key)) return defaultValue<T>();

    switch(T) {
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

  static Future<void> setValue<T>(String key, T value) async {
    switch(T) {
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

  static T defaultValue<T>() {
    switch(T) {
      case const (int) :
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
