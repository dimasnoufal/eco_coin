import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _preferences;

  SharedPreferencesService(this._preferences);

  static const String _keyHasLogin = "HAS_LOGIN";
  static const String _keyHasFinishOnboarding = "HAS_FINISH_ONBOARD";

  Future<void> setHasLoginPref(bool hasLogin) async {
    try {
      await _preferences.setBool(_keyHasLogin, hasLogin);
    } catch (e) {
      throw Exception("Failed to save theme mode.");
    }
  }

  bool getHasLoginPref() {
    return _preferences.getBool(_keyHasLogin) ?? false;
  }

  Future<void> setHasFinishOnboardingPref(bool hasFinish) async {
    try {
      await _preferences.setBool(_keyHasFinishOnboarding, hasFinish);
    } catch (e) {
      throw Exception("Failed to save daily reminder setting.");
    }
  }

  bool getHasFinishOnboardingPref() {
    return _preferences.getBool(_keyHasFinishOnboarding) ?? false;
  }
}
