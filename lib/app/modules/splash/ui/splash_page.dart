import 'package:eco_coin/app/helper/shared/app_color.dart';
import 'package:eco_coin/app/helper/utils.dart';
import 'package:eco_coin/app/provider/shared_pref_provider.dart';
import 'package:eco_coin/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  void _initializeApp() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      _navigateBasedOnPreferences();
    });
  }

  void _navigateBasedOnPreferences() {
    if (!mounted) return;

    final sharedPrefProvider = context.read<SharedPrefProvider>();

    if (sharedPrefProvider.isLoading) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _navigateBasedOnPreferences();
      });
      return;
    }

    String routeName;

    if (sharedPrefProvider.hasLogin) {
      routeName = Routes.home;
    } else {
      if (sharedPrefProvider.hasFinishOnboard) {
        routeName = Routes.login;
      } else {
        routeName = Routes.onboarding;
      }
    }

    Navigator.pushReplacementNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_splash_screen.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/ic_eco_coin_with_text.png',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 4),
              Text(
                Utils.appsVersion,
                style: const TextStyle(
                  color: AppColor.neutralWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
