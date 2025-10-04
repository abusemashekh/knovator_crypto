import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  final controller = Get.put(SplashController());

  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.accent],
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Obx(
                () => AnimatedOpacity(
                  opacity: controller.opacity.value,
                  duration: const Duration(milliseconds: 1200),
                  child: AnimatedScale(
                    scale: controller.scale.value,
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.elasticOut,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/splash.png',
                          height: size.height * .2,
                          width: size.width * .5,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Crypto Portfolio',
                          style: AppTextStyles.heading.copyWith(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Track Your Digital Assets',
                          style: AppTextStyles.subheading.copyWith(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Obx(
                () => AnimatedOpacity(
                  opacity: controller.opacity.value,
                  duration: const Duration(milliseconds: 1200),
                  child: Column(
                    children: [
                      Text(
                        'Powered by Knovator Technologies',
                        style: AppTextStyles.subheading.copyWith(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Innovate. Build. Deliver.',
                        style: AppTextStyles.subheading.copyWith(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
