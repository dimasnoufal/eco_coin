import 'package:eco_coin/app/modules/home/ui/home_view.dart';
import 'package:eco_coin/app/routes/app_routes.dart';
import 'package:eco_coin/app/routes/splash_page.dart';
import 'package:flutter/material.dart';

class AppPages {
  Route onRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.initial:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case Routes.onboarding:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Onboarding Page'))),
        );
      case Routes.home:
        return MaterialPageRoute(builder: (context) => const HomeView());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Unknown Page'))),
        );
    }
  }
}

// Note: Yotu can add providers in every page for local state providers.
