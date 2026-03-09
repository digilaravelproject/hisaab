import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeeklyBudgetController extends GetxController {
  // Mock data for the demonstration
  final weeklyLimit = 10000.0.obs;
  final spentAmount = 7500.0.obs;
  
  // Another mock state where limit is exceeded
  final isExceededState = false.obs;

  double get progress => spentAmount.value / weeklyLimit.value;
  double get remaining => weeklyLimit.value - spentAmount.value;
  bool get isExceeded => spentAmount.value > weeklyLimit.value;

  void toggleMockState() {
    isExceededState.value = !isExceededState.value;
    if (isExceededState.value) {
      spentAmount.value = 12000.0;
    } else {
      spentAmount.value = 7500.0;
    }
  }
}
