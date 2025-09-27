import 'package:eco_coin/app/modules/home/widget/camera_screen.dart';
import 'package:eco_coin/app/modules/home/widget/dashboard_screen.dart';
import 'package:eco_coin/app/modules/home/widget/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  final List<Widget> _pages = [
    Center(child: DashboardScreen()),
    Center(child: CameraScreen()),
    Center(child: ProfileScreen()),
  ];

  List<Widget> get pages => _pages;

  set currentIndex(int value) {
    _currentIndex = value;
    notifyListeners();
  }
}
