import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  String get appName => 'Face App';
  String get loadingText => ' set Pictures Through Ai';
  int get splashDuration => 4500;

  Color get backgroundColor1 => Color(0xFF0d1b2a);
  Color get backgroundColor2 => Color(0xFF1b263b);
  Color get primaryColor => Colors.orange;
  Color get textColor => Colors.white;
  Color get subtitleColor => Colors.white70;
  IconData get appIcon => Icons.psychology_alt; 

  @override
  void onInit() {
    super.onInit();
    _navigateToOnboarding();
  }

  Future<void> _navigateToOnboarding() async {
    await Future.delayed(Duration(milliseconds: splashDuration));
    Get.offNamed(Routes.ONBOARDING);
  }
}