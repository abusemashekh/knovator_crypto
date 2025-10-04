import 'package:get/get.dart';
import 'dart:async';
import '../../portfolio/views/portfolio_screen.dart';

class SplashController extends GetxController {
  final opacity = 0.0.obs;
  final scale = 0.5.obs;

  @override
  void onInit() {
    super.onInit();
    _startAnimation();
    _navigateToHome();
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 100), () {
      opacity.value = 1.0;
      scale.value = 1.0;
    });
  }

  void _navigateToHome() {
    Timer(const Duration(seconds: 3), () {
      Get.off(
            () => PortfolioScreen(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 800),
      );
    });
  }
}