import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:credit_debit/core/constants/image_constants.dart';
import 'package:credit_debit/core/theme/app_colors.dart';
import 'package:credit_debit/core/theme/theme_controller.dart';
import '../../language/controllers/localization_controller.dart';
import '../controllers/splash_controller.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _fadeSlideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Start entry animation
    _fadeSlideController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeSlideController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(
      CurvedAnimation(
        parent: _fadeSlideController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _fadeSlideController.forward();
  }

  @override
  void dispose() {
    _fadeSlideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final splashController = Get.find<SplashController>();

    return GetBuilder<ThemeController>(
        builder: (themeController) {
      final isDark = themeController.isDarkMode;
      final bgColor = isDark ? AppColors.slate900 : AppColors.slate50;
      final surfaceColor = isDark ? AppColors.slate800 : Colors.white;
      final textColor = isDark ? Colors.white : AppColors.slate800;
      final subtitleColor = isDark ? Colors.white60 : AppColors.slate500;
      final primaryColor = Theme.of(context).primaryColor;

      return Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            // Center Content: Logo and App Name
            Center(
              child: AnimatedBuilder(
                animation: _fadeSlideController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: child,
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Container with soft, premium shadow
                    Hero(
                      tag: 'app_logo',
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: isDark 
                                ? Colors.black.withOpacity(0.3)
                                : primaryColor.withOpacity(0.08),
                              blurRadius: 40,
                              spreadRadius: 8,
                              offset: const Offset(0, 10),
                            ),
                            BoxShadow(
                              color: isDark 
                                ? Colors.transparent
                                : Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              spreadRadius: 0,
                              offset: const Offset(0, 4),
                            )
                          ]
                        ),
                        child: Image.asset(ImageConstants.logo, width: 90),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    Text(
                      "Credit Debit",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Manage your finances",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white70 : primaryColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            
            // Bottom Content: Tagline and Loader
            Positioned(
              bottom: 48,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _fadeSlideController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: child!,
                    ),
                  );
                },
                child: Column(
                  children: [
                     Obx(
                      () => AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: splashController.isLoading.value ? 1.0 : 0.0,
                        child: SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                            backgroundColor: primaryColor.withOpacity(0.1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      "SECURE & FAST PAYMENTS",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.0,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
