import 'package:eco_coin/app/modules/home/provider/image_classification_provider.dart';
import 'package:eco_coin/app/modules/home/ui/home_view.dart';
import 'package:eco_coin/app/modules/login/login_screen.dart';
import 'package:eco_coin/app/modules/onboarding/onboarding_screen.dart';
import 'package:eco_coin/app/modules/profile/edit_profile/edit_profile_screen.dart';
import 'package:eco_coin/app/modules/profile/history/history_screen.dart';
import 'package:eco_coin/app/modules/profile/profile_screen.dart';
import 'package:eco_coin/app/modules/register/register_screen.dart';
import 'package:eco_coin/app/modules/result_detection/ui/result_detection.dart';
import 'package:eco_coin/app/modules/splash/splash_screen.dart';
import 'package:eco_coin/app/routes/app_routes.dart';
import 'package:eco_coin/app/services/image_classification_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppPages {
  Route onRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.initial:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case Routes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case Routes.home:
        return MaterialPageRoute(builder: (context) => const HomeView());
      case Routes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case Routes.editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case Routes.history:
        return MaterialPageRoute(builder: (_) => const HistoryScreen());
      case Routes.resultDetection:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => MultiProvider(
            providers: [
              Provider(create: (context) => ImageClassificationServices()),
              ChangeNotifierProvider(
                create: (context) => ImageClassificationProvider(
                  context.read<ImageClassificationServices>(),
                ),
              ),
            ],
            child: ResultDetection(
              arguments: settings.arguments as Map<String, dynamic>?,
            ),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Unknown Page'))),
        );
    }
  }
}

// Note: You can add providers in every page for local state providers.
