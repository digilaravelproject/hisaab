import 'package:hash_code/core/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/image_constants.dart';
import '../../../core/theme/theme_controller.dart';
import '../../language/controllers/localization_controller.dart';
import '../controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final splashController = Get.find<SplashController>();
    final themeController = Get.find<ThemeController>();

    return GetBuilder<ThemeController>(
        builder: (themeController) {
      return Scaffold(
        backgroundColor: themeController.isDarkMode
            ? Colors.black
            : Colors.white,

        body: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: CustomImageWidget(
                 imagePath:  ImageConstants.splashBackground,
                 fit: BoxFit.cover,
              ),
            ),

            // Logo and loading indicator
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(ImageConstants.logo, width: 200),

                  const SizedBox(height: 30),

                  // ElevatedButton(
                  //   onPressed: () {
                  //     themeController.toggleTheme();
                  //   },
                  //   child: Obx(() => Text(
                  //       themeController.isDarkMode ? "Switch to Light Mode" : "Switch to Dark Mode"
                  //   )),
                  // ),

                  // Loading indicator
                  Obx(
                    () => Visibility(
                      visible: splashController.isLoading.value,
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
