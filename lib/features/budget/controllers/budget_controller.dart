import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/custom_snackbar.dart';

class BudgetCategory {
  final String name;
  final IconData icon;
  final RxDouble targetAmount;

  BudgetCategory({required this.name, required this.icon, double target = 0.0})
      : targetAmount = target.obs;
}

class BudgetController extends GetxController {
  final List<BudgetCategory> categories = [
    BudgetCategory(name: 'Groceries', icon: Icons.shopping_cart_outlined, target: 5000),
    BudgetCategory(name: 'Rent', icon: Icons.home_outlined, target: 20000),
    BudgetCategory(name: 'Entertainment', icon: Icons.movie_outlined, target: 3000),
    BudgetCategory(name: 'Social', icon: Icons.people_outline, target: 2000),
    BudgetCategory(name: 'Transport', icon: Icons.directions_bus_outlined, target: 4000),
    BudgetCategory(name: 'Utilities', icon: Icons.lightbulb_outline, target: 2500),
    BudgetCategory(name: 'Savings', icon: Icons.account_balance_wallet_outlined, target: 10000),
    BudgetCategory(name: 'Other', icon: Icons.more_horiz_outlined, target: 1500),
  ].obs;

  void updateTarget(int index, double amount) {
    if (index >= 0 && index < categories.length) {
      categories[index].targetAmount.value = amount;
    }
  }

  double get totalBudget => categories.fold(0, (sum, item) => sum + item.targetAmount.value);
  
  // Simulated spent amount for demonstration (45% of budget)
  double get totalSpent => totalBudget * 0.45;

  void saveBudget() {
    // Simulate save logic
    Get.back();
    CustomSnackbar.showSuccess('Monthly budget targets saved successfully');
  }
}
