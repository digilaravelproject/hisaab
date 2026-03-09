import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';
import '../../home/screens/home_screen.dart';
import '../../transactions/screens/transactions_screen.dart';
import '../../business/screens/business_screen.dart';
import '../../reports/screens/reports_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/route_helper.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeScreen(),
      const TransactionsScreen(),
      const ReportsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: Obx(() => IndexedStack(
            index: controller.selectedIndex.value,
            children: pages,
          )),
      bottomNavigationBar: Obx(
        () => BottomAppBar(
          padding: EdgeInsets.zero,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          color: Colors.white,
          elevation: 10,
          child: SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, 'Home', controller),
                _buildNavItem(1, Icons.receipt_long_rounded, Icons.receipt_long_outlined, 'Transactions', controller),
                const SizedBox(width: 40), // Space for FAB
                _buildNavItem(2, Icons.bar_chart_rounded, Icons.bar_chart_outlined, 'Reports', controller),
                _buildNavItem(3, Icons.settings_rounded, Icons.settings_outlined, 'Settings', controller),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        heroTag: 'dashboard_fab',
        onPressed: () => _showAddOptions(context),
        backgroundColor: AppColors.primaryColor,
        elevation: 8, // Increased elevation for highlighting
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 36), // Slightly larger icon
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String label, DashboardController controller) {
    bool isSelected = controller.selectedIndex.value == index;
    return InkWell(
      onTap: () => controller.changeIndex(index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              color: isSelected ? AppColors.primaryColor : Colors.grey.shade400,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.primaryColor : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add New Entry',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
            ),
            const SizedBox(height: 30),
            _buildOptionItem(context, 'Add Cash Entry', Icons.money_rounded, Colors.blue),
            const SizedBox(height: 16),
            _buildOptionItem(context, 'Add Income', Icons.arrow_downward_rounded, Colors.green),
            const SizedBox(height: 16),
            _buildOptionItem(context, 'Add Expense', Icons.arrow_upward_rounded, Colors.red),
            const SizedBox(height: 16),
            _buildOptionItem(context, 'Add Bill', Icons.receipt_long_rounded, Colors.purple),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem(BuildContext context, String title, IconData icon, Color color) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      onTap: () {
        Navigator.pop(context);
        String type;
        if (title.contains('Income')) {
          type = 'Income';
        } else if (title.contains('Expense')) {
          type = 'Expense';
        } else if (title.contains('Bill')) {
          type = 'Bill';
        } else {
          type = 'Cash Entry';
        }
        Get.toNamed(RouteHelper.getAddEntryRoute(), arguments: {'type': type});
      },
    );
  }
}
