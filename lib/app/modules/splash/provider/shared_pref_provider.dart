import 'package:eco_coin/app/services/shared_preferences_services.dart';
import 'package:flutter/material.dart';

class SharedPrefProvider extends ChangeNotifier {
  final SharedPreferencesService _service;

  SharedPrefProvider(this._service) {
    _loadSplashState();
  }

  bool _hasLogin = false;
  bool _hasFinishOnboarding = false;
  String _message = "";
  bool _isLoading = true;

  bool get hasLogin => _hasLogin;
  bool get hasFinishOnboard => _hasFinishOnboarding;
  bool get isLoading => _isLoading;
  String get message => _message;

  void _loadSplashState() async {
    try {
      _isLoading = true;
      notifyListeners();

      _hasLogin = _service.getHasLoginPref();
      _hasFinishOnboarding = _service.getHasFinishOnboardingPref();

      _isLoading = false;
    } catch (e) {
      _hasLogin = false;
      _hasFinishOnboarding = false;
      _isLoading = false;
      _message = "Failed to load preferences";
    }
    notifyListeners();
  }

  Future<void> setHasLogin(bool hasLogin) async {
    try {
      await _service.setHasLoginPref(hasLogin);
      _hasLogin = hasLogin;
      _message = "";
    } catch (e) {
      _message = "Failed to set login preference";
    }
    notifyListeners();
  }

  Future<void> setHasFinishOnboarding(bool hasFinish) async {
    try {
      await _service.setHasFinishOnboardingPref(hasFinish);
      _hasFinishOnboarding = hasFinish;
      _message = "";
    } catch (e) {
      _message = "Failed to set onboarding preference";
    }
    notifyListeners();
  }
}
