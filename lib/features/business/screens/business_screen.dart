import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_theme.dart';
import '../../../routes/route_helper.dart';

class BusinessScreen extends StatelessWidget {
  const BusinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final List<Map<String, dynamic>> businesses = [
      {
        'name': 'My Farm',
        'type': 'Agriculture',
        'accounts': ['HDFC Bank', 'Cash'],
        'income': 120000.0,
        'expense': 45000.0,
      },
      {
        'name': 'City Shop',
        'type': 'Retail',
        'accounts': ['ICICI Bank'],
        'income': 85000.0,
        'expense': 92000.0, // Loss scenario
      },
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'My Businesses',
          style: AppTextTheme.lightTextTheme.displaySmall?.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton.icon(
              onPressed: () {
                // Get.toNamed(RouteHelper.getBusinessSetupRoute());
              },
              icon: const Icon(Icons.add_rounded, color: AppColors.primaryColor, size: 20),
              label: const Text(
                'Add New',
                style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
              ),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
        ],
      ),
      body: businesses.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: businesses.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return _buildBusinessCard(businesses[index]);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.storefront_rounded, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No Businesses Yet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your business to track income,\nexpenses, and bills separately.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessCard(Map<String, dynamic> business) {
    final double profit = business['income'] - business['expense'];
    final bool isProfit = profit >= 0;

    return InkWell(
      onTap: () {
        // Go to Business Details
        // Get.toNamed(RouteHelper.getBusinessDetailRoute(), arguments: {'businessName': business['name']});
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.storefront_rounded, color: AppColors.primaryColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        business['name'],
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                      ),
                      Text(
                        business['type'],
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
              ],
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Divider(height: 1),
            ),
            
            // Financial Summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatColumn('Income', business['income'], Colors.green.shade700),
                _buildStatColumn('Expense', business['expense'], Colors.red.shade700),
                _buildStatColumn(isProfit ? 'Profit' : 'Loss', profit.abs(), isProfit ? AppColors.primaryColor : Colors.orange.shade700),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Connected Banks
            Row(
              children: [
                Icon(Icons.account_balance_rounded, size: 14, color: Colors.grey.shade500),
                const SizedBox(width: 6),
                Text(
                  'Connected: ${business['accounts'].join(", ")}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, double amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          '₹${_formatCurrency(amount)}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color),
        ),
      ],
    );
  }
  
  String _formatCurrency(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}
