import 'package:eco_coin/app/helper/shared/app_color.dart';
import 'package:eco_coin/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure Flutter bindings are initialized
    WidgetsFlutterBinding.ensureInitialized();

    return MultiProvider(
      providers: [
        // Add your global providers here
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoCoin App',
      theme: AppColor.mainScheme,
      darkTheme: AppColor.darkScheme,
      // Adjust themeMode as needed
      themeMode: ThemeMode.light,
      onGenerateRoute: AppPages().onRoute,
    );
  }
}
