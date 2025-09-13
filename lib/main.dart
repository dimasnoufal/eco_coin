import 'package:eco_coin/app/helper/shared/app_color.dart';
import 'package:eco_coin/app/routes/app_pages.dart';
import 'package:eco_coin/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    // MultiProvider(
    //   providers: [
    //     // Add your global providers here
    //   ],
    //   child: const MainApp(),
    // ),
    const MainApp(),
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
