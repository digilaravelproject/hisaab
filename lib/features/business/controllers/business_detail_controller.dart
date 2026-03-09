import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessTransaction {
  final String title;
  final String date;
  final double amount;
  final bool isIncome;

  BusinessTransaction({
    required this.title,
    required this.date,
    required this.amount,
    required this.isIncome,
  });
}

class BusinessDetailController extends GetxController {
  final totalIncome = 125000.0.obs;
  final totalExpense = 45000.0.obs;
  
  double get netProfit => totalIncome.value - totalExpense.value;
  double get profitPercentage => totalIncome.value > 0 ? (netProfit / totalIncome.value) * 100 : 0.0;

  final monthlyData = [
    25000.0, 32000.0, 28000.0, 45000.0, 38000.0, 52000.0
  ].obs;

  final recentTransactions = <BusinessTransaction>[
    BusinessTransaction(title: 'Service Payment - Client A', date: 'Feb 27, 2026', amount: 15000, isIncome: true),
    BusinessTransaction(title: 'Office Supplies', date: 'Feb 25, 2026', amount: 2500, isIncome: false),
    BusinessTransaction(title: 'Consultation Fee', date: 'Feb 24, 2026', amount: 8000, isIncome: true),
    BusinessTransaction(title: 'Software Subscription', date: 'Feb 22, 2026', amount: 1200, isIncome: false),
    BusinessTransaction(title: 'Project Milestone - B', date: 'Feb 20, 2026', amount: 25000, isIncome: true),
  ].obs;
}
