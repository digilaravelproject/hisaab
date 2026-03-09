import 'package:get/get.dart';

class ComparisonItem {
  final String label;
  final double value1;
  final double value2;
  final double change;

  ComparisonItem({
    required this.label,
    required this.value1,
    required this.value2,
    required this.change,
  });
}

class ComparisonController extends GetxController {
  final selectedIndex = 0.obs;

  final monthlyComparison = <ComparisonItem>[
    ComparisonItem(label: 'Jan', value1: 45000, value2: 52000, change: 15.5),
    ComparisonItem(label: 'Feb', value1: 48000, value2: 46000, change: -4.1),
    ComparisonItem(label: 'Mar', value1: 42000, value2: 55000, change: 30.9),
  ].obs;

  final yearlyComparison = <ComparisonItem>[
    ComparisonItem(label: '2024', value1: 450000, value2: 580000, change: 28.8),
    ComparisonItem(label: '2025', value1: 580000, value2: 720000, change: 24.1),
  ].obs;

  final businessComparison = <ComparisonItem>[
    ComparisonItem(label: 'Farm', value1: 30000, value2: 35000, change: 16.6),
    ComparisonItem(label: 'Shop', value1: 25000, value2: 24000, change: -4.0),
    ComparisonItem(label: 'Rent', value1: 15000, value2: 18000, change: 20.0),
  ].obs;

  List<ComparisonItem> get currentData {
    switch (selectedIndex.value) {
      case 0: return monthlyComparison;
      case 1: return yearlyComparison;
      case 2: return businessComparison;
      default: return monthlyComparison;
    }
  }

  void setTabIndex(int index) {
    selectedIndex.value = index;
  }
}
