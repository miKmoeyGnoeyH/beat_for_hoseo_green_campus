import 'package:shared_preferences/shared_preferences.dart';

class PrefsProvider {
  static final PrefsProvider _instance = PrefsProvider._internal();
  late final SharedPreferences _prefs;

  SharedPreferences get prefs => _prefs;

  factory PrefsProvider() => _instance;
  PrefsProvider._internal() {
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  T getValueAs<T>(String key) {
    switch(T) {
      case const (int):
        return _prefs.getInt(key) as T? ?? _getDefaultValue<T>();
      case const (double):
        return _prefs.getDouble(key) as T? ?? _getDefaultValue<T>();
      case const (String):
        return _prefs.getString(key) as T? ?? _getDefaultValue<T>();
      default:
        throw Exception('Not supported type');
    }
  }

  T _getDefaultValue<T>() {
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
