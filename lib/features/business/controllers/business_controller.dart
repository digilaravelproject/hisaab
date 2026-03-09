import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessController extends GetxController {
  final businessNameController = TextEditingController();
  final incomeController = TextEditingController();
  final investmentController = TextEditingController();
  
  final businessType = 'Service'.obs;
  final businessTypes = ['Service', 'Retail', 'Manufacturing', 'Technology', 'Other'];
  
  final linkedAccounts = <String>[].obs;

  void setBusinessType(String? value) {
    if (value != null) businessType.value = value;
  }

  void toggleAccount(String accountName) {
    if (linkedAccounts.contains(accountName)) {
      linkedAccounts.remove(accountName);
    } else {
      linkedAccounts.add(accountName);
    }
  }

  bool validate() {
    if (businessNameController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter a business name',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red);
      return false;
    }
    return true;
  }

  void createBusiness() {
    if (validate()) {
      // Simulate API call
      Get.back();
      Get.snackbar('Success', 'Business "${businessNameController.text}" created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green);
    }
  }

  @override
  void onClose() {
    businessNameController.dispose();
    incomeController.dispose();
    investmentController.dispose();
    super.onClose();
  }
}
