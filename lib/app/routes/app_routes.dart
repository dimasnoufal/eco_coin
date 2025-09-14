abstract class Routes {
  Routes._();

  static const String initial = _Paths.initial;
  static const String onboarding = _Paths.onboarding;
  static const String login = _Paths.login;
  static const String register = _Paths.register;
  static const String home = _Paths.home;
  static const String profile = _Paths.profile;
}

abstract class _Paths {
  _Paths._();

  static const initial = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const profile = '/profile';
}
