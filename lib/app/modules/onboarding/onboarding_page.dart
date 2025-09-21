import 'package:eco_coin/app/helper/shared/app_color.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: Image.asset(data.imagePath, fit: BoxFit.contain),
            ),
          ),

          const SizedBox(height: 48),

          Text(
            data.title,
            style: AppColor.bold.copyWith(
              fontSize: 28,
              color: AppColor.neutralBlack,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          Text(
            data.description,
            style: AppColor.regular.copyWith(
              fontSize: 16,
              color: AppColor.neutral40,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String imagePath;

  OnboardingData({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}
