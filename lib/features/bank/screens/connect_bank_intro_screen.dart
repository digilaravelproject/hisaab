import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_theme.dart';
import '../../../core/widgets/custom_primary_button.dart';
import '../../../core/widgets/liquid_background.dart';
import '../../../routes/route_helper.dart';

class ConnectBankIntroScreen extends StatelessWidget {
  const ConnectBankIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LiquidBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Custom Header
              Padding(
                padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.offAllNamed(RouteHelper.getDashboardRoute()),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 20,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Bank Integration',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40), // Balance the back button
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Illustration (Placeholder Icon)
              Center(
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.12),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.account_balance_rounded,
                      size: 54,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Main Text content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  children: [
                    Text(
                      'Connect Your\nBank Accounts',
                      textAlign: TextAlign.center,
                      style: AppTextTheme.lightTextTheme.displayMedium?.copyWith(
                        color: AppColors.textColorPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                        height: 1.25,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Connect your bank to automatically track transactions.',
                      textAlign: TextAlign.center,
                      style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
                        color: AppColors.textColorSecondary,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Bottom Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                child: Column(
                  children: [
                    CustomPrimaryButton(
                      text: 'Connect Bank',
                      fontSize: 16,
                      onPressed: () {
                        Get.toNamed(RouteHelper.getBankLinkRoute());
                      },
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () {
                        Get.offAllNamed(RouteHelper.getDashboardRoute());
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
