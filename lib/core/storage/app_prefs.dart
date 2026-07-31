import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  AppPrefs._();

  static const _hasSeenLandingKey = 'has_seen_landing';

  static Future<bool> getHasSeenLanding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasSeenLandingKey) ?? false;
  }

  static Future<void> setHasSeenLanding(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenLandingKey, value);
  }
}
