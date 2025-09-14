import 'package:eco_coin/app/helper/shared/app_color.dart';
import 'package:eco_coin/app/helper/utils.dart';
import 'package:eco_coin/app/routes/app_routes.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding();
  }

  void _navigateToOnboarding() {
    Future.delayed(Duration(milliseconds: 2000), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, Routes.onboarding);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
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
              SizedBox(height: 4),
              Text(
                Utils.appsVersion,
                style: TextStyle(
                  color: AppColor.neutralWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
