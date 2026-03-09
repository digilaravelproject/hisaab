import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CashEntryController extends GetxController {
  var isCredit = true.obs;
  var amount = ''.obs;
  var selectedDate = DateTime.now().obs;
  var selectedPurpose = 'General'.obs;
  var isBusiness = true.obs;

  final List<String> purposes = [
    'General',
    'Salary',
    'Groceries',
    'Rent',
    'Social',
    'Investment',
    'Other'
  ];

  void toggleType(bool? value) {
    if (value != null) {
      isCredit.value = value;
    }
  }

  void updateAmount(String value) {
    amount.value = value;
  }

  void updateDate(DateTime date) {
    selectedDate.value = date;
  }

  void updatePurpose(String? purpose) {
    if (purpose != null) {
      selectedPurpose.value = purpose;
    }
  }

  void toggleEntity(bool? value) {
    if (value != null) {
      isBusiness.value = value;
    }
  }

  void saveTransaction() {
    if (amount.value.isEmpty || double.tryParse(amount.value) == null) {
      Get.snackbar(
        'Error',
        'Please enter a valid amount',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }

    // Simulate save logic
    Get.back();
    Get.snackbar(
      'Success',
      'Cash entry saved successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withValues(alpha: 0.8),
      colorText: Colors.white,
    );
  }
}
