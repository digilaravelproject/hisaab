import 'package:flutter/material.dart';
import 'package:credit_debit/core/theme/app_colors.dart';
import 'package:get/get.dart';
import '../controllers/intro_controller.dart';

class IntroScreen extends GetView<IntroController> {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Colors matching the sample image
    final Color textColor = AppColors.slate700;
    final Color subtitleColor = AppColors.slate400;
    final Color accentColor = AppColors.primaryColor; // Primary App Color

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // Top 'Skip' Button
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 20),
              child: Align(
                alignment: Alignment.topRight,
                child: Obx(() => Visibility(
                      visible: controller.currentPage.value < 3,
                      maintainSize: true, 
                      maintainAnimation: true,
                      maintainState: true,
                      child: TextButton(
                        onPressed: controller.getStarted,
                        style: TextButton.styleFrom(
                          foregroundColor: textColor.withOpacity(0.7),
                        ),
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )),
              ),
            ),

            // Expanded PageView for Central Content
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildPageContent(
                    imagePath: 'assets/images/intro_1.png',
                    title: 'Automatically Track All\nCredit & Debit Transactions',
                    description: 'Say goodbye to manual entry. Your financial life,\nautomated and simplified in real-time.',
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),
                  _buildPageContent(
                    imagePath: 'assets/images/intro_2.png',
                    title: 'Separate Personal &\nBusiness Finances Easily',
                    description: 'Maintain laser focus on your business goals while\nkeeping personal expenses completely distinct.',
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),
                  _buildPageContent(
                    imagePath: 'assets/images/intro_3.png',
                    title: 'Set Monthly Targets &\nGet Smart Budget Alerts',
                    description: 'Stay disciplined with weekly notifications\nand track your spending continuously.',
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),
                  _buildPageContent(
                    imagePath: 'assets/images/intro_2.png',
                    title: 'Store Bills &\nGenerate Reports Anytime',
                    description: 'Securely manage purchase receipts and generate\ninstant PDF/Excel exports for audits.',
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),
                ],
              ),
            ),

            // Bottom Navigation Area
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, bottom: 40, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dot Indicators
                  Obx(() => Row(
                        children: List.generate(
                          4,
                          (index) => _buildIndicator(
                              index == controller.currentPage.value, accentColor),
                        ),
                      )),

                  // Next / Get Started Button
                  Obx(() {
                    bool isLastPage = controller.currentPage.value == 3;
                    return InkWell(
                      onTap: controller.nextPage,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: accentColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(
                          isLastPage ? Icons.check : Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent({
    required String imagePath,
    required String title,
    required String description,
    required Color textColor,
    required Color subtitleColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // The Illustration
          Image.asset(
            imagePath,
            height: 320,
            fit: BoxFit.contain,
          ),
          
          const SizedBox(height: 60),
          
          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: subtitleColor,
              fontSize: 13,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive, Color accentColor) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 6),
      height: 6,
      width: 6,
      decoration: BoxDecoration(
        color: isActive ? accentColor : accentColor.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
    );
  }
}
