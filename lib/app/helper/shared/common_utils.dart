import 'package:eco_coin/app/helper/shared/app_color.dart';
import 'package:eco_coin/app/modules/home/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonUtils {
  static bool falsyChecker(dynamic value) {
    bool isEmpty = false;
    bool isZero = false;
    bool isNull = value == null;
    if (value is int || value is double || value is num) {
      isZero = value == 0 || value == 0.0;
    } else {
      try {
        if (!isNull) isEmpty = value?.isEmpty;
      } catch (e) {
        isEmpty = false;
      }
    }
    return isNull || isEmpty || isZero;
  }

  static void showComingSoonSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur akan segera dikembangkan di next MVP'),
        backgroundColor: AppColor.neutral40,
      ),
    );
  }

  static Future<void> launchCommunityWebsite(BuildContext context) async {
    const url = 'https://www.greenpeace.org/indonesia/';

    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tidak dapat membuka website'),
              backgroundColor: AppColor.rubyDefault,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColor.rubyDefault,
          ),
        );
      }
    }
  }

  static void navigateToCamera(BuildContext context) {
    try {
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      homeProvider.currentIndex = 1; // Switch to camera tab
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak dapat membuka kamera'),
          backgroundColor: AppColor.rubyDefault,
        ),
      );
    }
  }
}
