import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_theme.dart';
import '../../../core/utils/transaction_helper.dart';
import '../controllers/reports_controller.dart';

class ReportsScreen extends GetView<ReportsController> {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: const Text(
          'Reports',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.slate800,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined, color: AppColors.primaryColor, size: 26),
            onPressed: () => _showExportBottomSheet(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.transactionController.loadTransactions(isRefresh: true),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // Important for RefreshIndicator
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMonthSelector(),
              if (controller.businesses.length > 2) _buildBusinessSelector(),
              _buildSummaryCards(),
              _buildIncomeExpenseChart(),
              _buildCategoryBreakdown(),
              _buildComparisonCard(),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.months.length,
        itemBuilder: (context, index) {
          return Obx(() {
            final isSelected = controller.selectedMonthIndex.value == index;
            return GestureDetector(
              onTap: () => controller.onMonthChanged(index),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryColor : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected ? [
                    BoxShadow(color: AppColors.primaryColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
                  ] : null,
                ),
                child: Center(
                  child: Text(
                    controller.months[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildBusinessSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedBusiness.value,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            onChanged: (val) => controller.selectedBusiness.value = val!,
            items: controller.businesses.map((b) => DropdownMenuItem(
              value: b,
              child: Text(b, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            )).toList(),
          ),
        ),
      )),
    );
  }

  Widget _buildSummaryCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Obx(() => Row(
        children: [
          _buildSummaryCard('Income', controller.totalIncome, AppColors.emerald500, Icons.arrow_downward_rounded),
          const SizedBox(width: 12),
          _buildSummaryCard('Expense', controller.totalExpense, AppColors.rose500, Icons.arrow_upward_rounded),
          const SizedBox(width: 12),
          _buildSummaryCard('Net', controller.netProfit, controller.netProfit >= 0 ? AppColors.primaryColor : Colors.orange, Icons.account_balance_wallet_outlined),
        ],
      )),
    );
  }

  Widget _buildSummaryCard(String title, double amount, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '₹${NumberFormat('#,##,###').format(amount)}',
                style: TextStyle(color: AppColors.slate800, fontSize: 15, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeExpenseChart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Income vs Expense', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Container(
            height: 220,
            padding: const EdgeInsets.only(top: 20, right: 20, left: 0, bottom: 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Obx(() {
              final weeklyData = controller.weeklyData;
              double maxAmount = 0;
              for (var data in weeklyData) {
                if (data['income']! > maxAmount) maxAmount = data['income']!;
                if (data['expense']! > maxAmount) maxAmount = data['expense']!;
              }
              maxAmount = maxAmount == 0 ? 10000 : maxAmount * 1.2;

              return BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxAmount,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['1-7', '8-14', '15-21', '22-30'];
                          final index = value.toInt();
                          if (index < 0 || index >= days.length) return const SizedBox();
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(days[index], style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(weeklyData.length, (i) {
                    return _makeGroupData(i, weeklyData[i]['income']!, weeklyData[i]['expense']!);
                  }),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double income, double expense) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(toY: income, color: AppColors.emerald500, width: 12, borderRadius: BorderRadius.circular(4)),
        BarChartRodData(toY: expense, color: AppColors.rose500, width: 12, borderRadius: BorderRadius.circular(4)),
      ],
    );
  }

  Widget _buildCategoryBreakdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Expense Breakdown', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.slate800)),
          const SizedBox(height: 20),
          Obx(() {
            final data = controller.categoryBreakdown;
            if (data.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(Icons.pie_chart_outline_rounded, size: 40, color: Colors.grey.shade300),
                    const SizedBox(height: 12),
                    Text('No expense data for this month', style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
                  ],
                ),
              );
            }
            
            final total = data.values.fold(0.0, (s, e) => s + e);
            final sortedCategories = data.keys.toList()..sort((a, b) => data[b]!.compareTo(data[a]!));

            return Column(
              children: [
                // Pie Chart Row
                Row(
                  children: [
                    SizedBox(
                      width: 140,
                      height: 140,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 35,
                          sections: sortedCategories.map((cat) {
                            final val = data[cat]!;
                            final index = sortedCategories.indexOf(cat);
                            final color = index == 0 ? AppColors.primaryColor : AppColors.primaryColor.withOpacity((1.0 - (index * 0.2)).clamp(0.1, 0.8));
                            return PieChartSectionData(
                              color: color,
                              value: val,
                              radius: 35,
                              showTitle: false,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Expense',
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${NumberFormat('#,##,###').format(total)}',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.slate800),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Across ${data.length} categories',
                            style: TextStyle(color: AppColors.primaryColor.withOpacity(0.8), fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                
                // Detailed List
                ...sortedCategories.map((cat) {
                  final val = data[cat]!;
                  final percentage = (val / total * 100).toStringAsFixed(1);
                  final index = sortedCategories.indexOf(cat);
                  final color = index == 0 ? AppColors.primaryColor : AppColors.primaryColor.withOpacity((1.0 - (index * 0.2)).clamp(0.1, 0.8));
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                              child: Icon(TransactionHelper.getCategoryIcon(cat), color: color, size: 18),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(cat, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.slate800, fontSize: 14)),
                                  Text('$percentage% of total', style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                                ],
                              ),
                            ),
                            Text(
                              '₹${NumberFormat('#,##,###').format(val)}',
                              style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.slate800, fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: val / total,
                            backgroundColor: Colors.grey.shade100,
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildComparisonCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Comparison', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryColor.withOpacity(0.05), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primaryColor.withOpacity(0.1)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('vs Last Month', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                      child: const Text('GOOD GROWTH', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryColor)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildComparisonItem('Income', controller.incomeGrowth),
                const Divider(height: 24),
                _buildComparisonItem('Expense', controller.expenseGrowth),
                const Divider(height: 24),
                _buildComparisonItem('Profit', controller.profitGrowth),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonItem(String title, double growth) {
    final isPositive = growth >= 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        Row(
          children: [
            Icon(
              isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
              size: 18,
              color: isPositive ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 4),
            Text(
              '${isPositive ? '+' : ''}$growth%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isPositive ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Custom date picker removed in favor of month selector

  void _showExportBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Export Financial Report', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.picture_as_pdf, color: Colors.red),
              ),
              title: const Text('Download PDF', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Best for printing and sharing'),
              onTap: () {
                Get.back();
                controller.exportPDF();
              },
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.table_view, color: Colors.green),
              ),
              title: const Text('Download Excel', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Best for data analysis'),
              onTap: () {
                Navigator.pop(context);
                controller.exportExcel();
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
