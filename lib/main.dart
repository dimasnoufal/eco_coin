import 'dart:io';

import 'package:eco_coin/app/helper/shared/app_color.dart';
import 'package:eco_coin/app/helper/shared/logger.dart';
import 'package:eco_coin/app/modules/home/provider/home_provider.dart';
import 'package:eco_coin/app/modules/splash/provider/shared_pref_provider.dart';
import 'package:eco_coin/app/routes/app_pages.dart';
import 'package:eco_coin/app/services/shared_preferences_services.dart';
import 'package:eco_coin/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final sharedPreferencesService = SharedPreferencesService(prefs);

  // Debug permission status on app start
  if (Platform.isIOS) {
    printY('=== iOS PERMISSION DEBUG ===');
    final cameraStatus = await Permission.camera.status;
    printY('Camera permission status: $cameraStatus');
    printY('===========================');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(
          create: (_) => SharedPrefProvider(sharedPreferencesService),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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
