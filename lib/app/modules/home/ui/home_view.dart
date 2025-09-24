import 'dart:io';

import 'package:animations/animations.dart';
import 'package:eco_coin/app/helper/shared/app_color.dart';
import 'package:eco_coin/app/helper/shared/dialogs.dart';
import 'package:eco_coin/app/helper/shared/logger.dart';
import 'package:eco_coin/app/modules/home/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (value, result) {
        printInfo('onPopInvokedWithResult: $value, result: $result');
        Dialogs.showExitDialog(
          context: context,
          onExit: () {
            exit(0);
          },
        );
      },
      child: Scaffold(
        body: PageTransitionSwitcher(
          transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
            return SharedAxisTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              fillColor: AppColor.kPage,
              child: child,
            );
          },
          duration: const Duration(milliseconds: 300),
          child: context
              .watch<HomeProvider>()
              .pages[context.watch<HomeProvider>().currentIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: context.watch<HomeProvider>().currentIndex,
          onTap: (index) {
            context.read<HomeProvider>().currentIndex = index;
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt_rounded),
              label: 'Camera',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
