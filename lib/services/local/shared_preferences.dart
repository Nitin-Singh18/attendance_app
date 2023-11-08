import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static late SharedPreferences _preferences;

  static Future<void> open() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<bool> saveQR(String key, String value) async {
    return await _preferences.setString(key, value);
  }

  String? getQR(String key) {
    return _preferences.getString(key);
  }
}
