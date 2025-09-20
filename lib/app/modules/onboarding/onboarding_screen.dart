import 'package:eco_coin/app/helper/shared/app_color.dart';
import 'package:eco_coin/app/helper/shared/widget/shared_button.dart';
import 'package:eco_coin/app/modules/onboarding/onboarding_page.dart';
import 'package:eco_coin/app/provider/shared_pref_provider.dart';
import 'package:eco_coin/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      title: "Deteksi Sampah",
      description:
          "Gunakan kamera untuk mengidentifikasi jenis sampah yang dapat didaur ulang secara otomatis",
      imagePath: "assets/images/image_onboarding_page_one.png",
    ),
    OnboardingData(
      title: "Dapatkan EcoCoins",
      description:
          "Kumpulkan koin digital setiap kali berhasil mendaur ulang sampah dan berkontribusi untuk lingkungan",
      imagePath: "assets/images/image_onboarding_page_two.png",
    ),
    OnboardingData(
      title: "Komunitas Hijau",
      description:
          "Bergabung dengan komunitas pecinta lingkungan dan berkolaborasi untuk mencapai lingkungan hijau",
      imagePath: "assets/images/image_onboarding_page_three.png",
    ),
  ];

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _finishOnboarding() async {
    final sharedPrefProvider = context.read<SharedPrefProvider>();
    await sharedPrefProvider.setHasFinishOnboarding(true);

    if (mounted) {
      Navigator.pushReplacementNamed(context, Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.emeraldBgLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(data: _onboardingData[index]);
                },
              ),
            ),

            _buildPageIndicator(),

            _buildNextButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          if (_currentPage > 0)
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColor.neutralWhite,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _previousPage,
                icon: const Icon(Icons.arrow_back_ios),
                color: AppColor.neutralBlack,
                iconSize: 20,
              ),
            )
          else
            const SizedBox(width: 48),

          const Spacer(),

          if (_currentPage < _onboardingData.length - 1)
            TextButton(
              onPressed: _finishOnboarding,
              child: Text(
                "Lewati",
                style: AppColor.medium.copyWith(
                  fontSize: 16,
                  color: AppColor.neutralBlack,
                ),
              ),
            )
          else
            const SizedBox(width: 64),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          _onboardingData.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _currentPage == index
                  ? AppColor.emeraldDefault
                  : AppColor.neutral30,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: PrimaryButton(text: _getButtonText(), onPressed: _nextPage),
    );
  }

  String _getButtonText() {
    switch (_currentPage) {
      case 0:
        return "Selanjutnya";
      case 1:
        return "Selanjutnya";
      case 2:
        return "Mulai Sekarang";
      default:
        return "Selanjutnya";
    }
  }
}
