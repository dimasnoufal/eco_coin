import 'package:eco_coin/app/modules/home/provider/image_classification_provider.dart';
import 'package:eco_coin/app/modules/home/ui/home_view.dart';
import 'package:eco_coin/app/modules/result_detection/ui/result_detection.dart';
import 'package:eco_coin/app/routes/app_routes.dart';
import 'package:eco_coin/app/routes/splash_page.dart';
import 'package:eco_coin/app/services/image_classification_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      case Routes.resultDetection:
        return MaterialPageRoute(
          settings: settings, // Pass settings to make arguments available
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
