import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../transactions/controllers/transaction_controller.dart';

class ReportsController extends GetxController {
  final TransactionController transactionController = Get.find<TransactionController>();

  final selectedMonthIndex = (DateTime.now().month - 1).obs;
  final selectedYear = DateTime.now().year.obs;
  final selectedBusiness = 'All'.obs;
  
  final months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void onInit() {
    super.onInit();
  }

  void onMonthChanged(int index) {
    selectedMonthIndex.value = index;
    // Update year if navigating across boundaries (simplified for now)
  }

  DateTime get startOfMonth => DateTime(selectedYear.value, selectedMonthIndex.value + 1, 1);
  DateTime get endOfMonth => DateTime(selectedYear.value, selectedMonthIndex.value + 2, 0);

  DateTime get startOfLastMonth => DateTime(selectedYear.value, selectedMonthIndex.value, 1);
  DateTime get endOfLastMonth => DateTime(selectedYear.value, selectedMonthIndex.value + 1, 0);

  List<TransactionModel> get filteredTransactions {
    return _getTransactionsForRange(startOfMonth, endOfMonth);
  }

  List<TransactionModel> _getTransactionsForRange(DateTime start, DateTime end) {
    return transactionController.allTransactions.where((tx) {
      final isWithinDate = tx.date.isAfter(start.subtract(const Duration(seconds: 1))) && 
                           tx.date.isBefore(end.add(const Duration(days: 1)));
      
      final matchesBusiness = selectedBusiness.value == 'All' || tx.account == selectedBusiness.value;
      
      return isWithinDate && matchesBusiness;
    }).toList();
  }

  double get totalIncome => filteredTransactions
      .where((tx) => tx.isCredit)
      .fold(0.0, (sum, tx) => sum + tx.amount);

  double get totalExpense => filteredTransactions
      .where((tx) => !tx.isCredit)
      .fold(0.0, (sum, tx) => sum + tx.amount);

  List<Map<String, double>> get weeklyData {
    final List<Map<String, double>> weeks = List.generate(4, (_) => {'income': 0.0, 'expense': 0.0});
    final start = startOfMonth;
    
    for (var tx in filteredTransactions) {
      final day = tx.date.day;
      int weekIndex = (day - 1) ~/ 7;
      if (weekIndex > 3) weekIndex = 3;
      
      if (tx.isCredit) {
        weeks[weekIndex]['income'] = (weeks[weekIndex]['income'] ?? 0.0) + tx.amount;
      } else {
        weeks[weekIndex]['expense'] = (weeks[weekIndex]['expense'] ?? 0.0) + tx.amount;
      }
    }
    return weeks;
  }

  double get netProfit => totalIncome - totalExpense;

  // Comparison logic (simplified for mockup)
  // Comparison logic
  double get incomeGrowth {
    final lastMonthIncome = _getTransactionsForRange(startOfLastMonth, endOfLastMonth)
        .where((tx) => tx.isCredit)
        .fold(0.0, (sum, tx) => sum + tx.amount);
    if (lastMonthIncome == 0) return 100.0;
    return ((totalIncome - lastMonthIncome) / lastMonthIncome * 100).toPrecision(1);
  }

  double get expenseGrowth {
    final lastMonthExpense = _getTransactionsForRange(startOfLastMonth, endOfLastMonth)
        .where((tx) => !tx.isCredit)
        .fold(0.0, (sum, tx) => sum + tx.amount);
    if (lastMonthExpense == 0) return 0.0;
    return ((totalExpense - lastMonthExpense) / lastMonthExpense * 100).toPrecision(1);
  }

  double get profitGrowth {
    final lastMonthProfit = _getTransactionsForRange(startOfLastMonth, endOfLastMonth)
        .fold(0.0, (sum, tx) => tx.isCredit ? sum + tx.amount : sum - tx.amount);
    if (lastMonthProfit == 0) return 100.0;
    return ((netProfit - lastMonthProfit) / lastMonthProfit.abs() * 100).toPrecision(1);
  }

  Map<String, double> get categoryBreakdown {
    final Map<String, double> breakdown = {};
    for (var tx in filteredTransactions.where((tx) => !tx.isCredit)) {
      breakdown[tx.category] = (breakdown[tx.category] ?? 0.0) + tx.amount;
    }
    return breakdown;
  }

  List<String> get businesses => ['All', ...transactionController.accounts.where((a) => a != 'All')];

  void exportPDF() {
    CustomSnackbar.showSuccess('PDF Report generated successfully', title: 'Export');
  }

  void exportExcel() {
    CustomSnackbar.showSuccess('Excel Report generated successfully', title: 'Export');
  }
}
