import 'dart:async';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class OnboardingController extends GetxController {
  // Use a reactive integer to track the current image index for animation.
  var currentImageIndex = 0.obs;
  // Use a reactive integer to track the current page index.
  var currentPage = 0.obs;

  late Timer _timer;
  late PageController pageController;

  // Pages data including two images for each page.
  final List<Map<String, dynamic>> pages = [
    {
      "images": ["assets/boarding one .jpg", "assets/boarding 2.jpg"],
      "title": "Welcome to FaceApp",
      "subtitle": "Transform your photos with AI-powered filters and effects"
    },
    {
      "images": ["assets/boarding 3.jpg", "assets/boarding 4.jpg"],
      "title": "Smart & Fast Solutions",
      "subtitle": "Get professional results in seconds with our advanced technology"
    },
    {
      "images": ["assets/boarding 5.jpg", "assets/boarding 6.jpg"],
      "title": "Get Started Now!",
      "subtitle": "Join millions of users creating amazing photos every day"
    },
  ];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    // Start the timer to switch images on a loop.
    startImageSwitch();
  }

  // Method to automatically switch between the two images on each page.
  void startImageSwitch() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      currentImageIndex.value = currentImageIndex.value == 0 ? 1 : 0;
    });
  }

  // Updates the current page index when the user swipes.
  void changePage(int index) {
    currentPage.value = index;
  }

  // Navigates to the next onboarding page or to the home screen.
  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offAllNamed(Routes.HOME);
    }
  }

  // Skips the onboarding and navigates directly to the home screen.
  void skipOnboarding() {
    Get.offAllNamed(Routes.HOME);
  }

  @override
  void onClose() {
    // Cancel the timer to prevent memory leaks.
    _timer.cancel();
    pageController.dispose();
    super.onClose();
  }
}
