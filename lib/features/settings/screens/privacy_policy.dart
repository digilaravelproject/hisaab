import 'package:credit_debit/core/constants/app_constants.dart';
import 'package:credit_debit/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import '../../help_support/controllers/help_support_controller.dart';

class PrivacyPolicyScreen extends GetView<HelpAndSupportController> {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch privacy policy if not already fetched or every time we enter
    controller.fetchPage(AppConstants.privacyPolicyUrl);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Privacy Policy',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.slate800)),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.slate800, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.staticPage.value == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        if (controller.staticPage.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_rounded, size: 48, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                const Text('No content available', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchPage(AppConstants.privacyPolicyUrl),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final page = controller.staticPage.value!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HtmlWidget(
                page.content,
                textStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade700,
                  height: 1.6,
                ),
                customStylesBuilder: (element) {
                   if (element.localName == 'h2') {
                    return {
                      'font-size': '20px',
                      'font-weight': 'bold',
                      'color': '#1E293B', // AppColors.slate800
                      'margin-bottom': '16px',
                      'margin-top': '24px',
                    };
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }
}
