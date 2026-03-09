import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../routes/route_helper.dart';

class IntroController extends GetxController {
  var currentPage = 0.obs;
  final pageController = PageController();

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < 3) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    } else {
      getStarted();
    }
  }

  void getStarted() {
    // Navigate to Bank Link (Bridging from Intro)
    Get.offAllNamed(RouteHelper.getBankLinkRoute());
  }
}
