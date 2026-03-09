import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/comparison_controller.dart';

class ComparisonScreen extends StatelessWidget {
  const ComparisonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ComparisonController());

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Comparison Reports', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildTabs(controller),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(Dimensions.height20),
              child: Column(
                children: [
                  _buildComparisonChart(controller),
                  SizedBox(height: Dimensions.height30),
                  _buildDetailsList(controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(ComparisonController controller) {
    final tabs = ['Monthly', 'Yearly', 'Business'];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(tabs.length, (index) {
          return Obx(() {
            final isSelected = controller.selectedIndex.value == index;
            return GestureDetector(
              onTap: () => controller.setTabIndex(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textColorSecondary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            );
          });
        }),
      ),
    );
  }

  Widget _buildComparisonChart(ComparisonController controller) {
    return Container(
      height: 250,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() {
        final data = controller.currentData;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: data.map((item) {
            return _buildBarGroup(item);
          }).toList(),
        );
      }),
    );
  }

  Widget _buildBarGroup(ComparisonItem item) {
    const maxBarHeight = 150.0;
    final maxValue = [item.value1, item.value2].fold(0.0, (val, e) => e > val ? e : val);
    
    final h1 = (item.value1 / maxValue) * maxBarHeight;
    final h2 = (item.value2 / maxValue) * maxBarHeight;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 14,
              height: h1,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ),
            const SizedBox(width: 4),
            Container(
              width: 14,
              height: h2,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(item.label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDetailsList(ComparisonController controller) {
    return Obx(() {
      final data = controller.currentData;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Detailed Comparison', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: Dimensions.height15),
          ...data.map((item) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Dimensions.radius15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('Previous: ₹${item.value1.toStringAsFixed(0)}', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('₹${item.value2.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          item.change >= 0 ? Icons.trending_up : Icons.trending_down,
                          color: item.change >= 0 ? Colors.green : Colors.red,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${item.change.abs().toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: item.change >= 0 ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )).toList(),
        ],
      );
    });
  }
}
