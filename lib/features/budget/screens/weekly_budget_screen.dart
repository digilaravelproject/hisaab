import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/weekly_budget_controller.dart';

class WeeklyBudgetScreen extends StatelessWidget {
  const WeeklyBudgetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WeeklyBudgetController());

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Weekly Budget', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.textColorPrimary,
      ),
      body: Obx(() {
        final double progress = controller.progress;
        final bool isExceeded = controller.isExceeded;
        final Color statusColor = isExceeded ? AppColors.errorColor : AppColors.successColor;

        return SingleChildScrollView(
          padding: EdgeInsets.all(Dimensions.height20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Card
              _buildSummaryCard(controller, statusColor, isExceeded),
              SizedBox(height: Dimensions.height30),

              // Progress Section
              Text(
                'Spending Progress',
                style: TextStyle(
                  fontSize: Dimensions.font18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColorPrimary,
                ),
              ),
              SizedBox(height: Dimensions.height20),
              _buildProgressBar(progress, statusColor),
              SizedBox(height: Dimensions.height10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('₹0', style: TextStyle(color: Colors.grey[600])),
                  Text('Limit: ₹${controller.weeklyLimit.value.toStringAsFixed(0)}', 
                    style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textColorPrimary)),
                ],
              ),
              SizedBox(height: Dimensions.height45),

              // Insights section
              _buildInsightCard(controller, isExceeded),
              
              SizedBox(height: Dimensions.height45),
              
              // Mock state toggle for testing
              Center(
                child: TextButton(
                  onPressed: controller.toggleMockState,
                  child: Text(
                    controller.isExceededState.value ? "Reset to Normal" : "Simulate Exceeded Limit",
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCard(WeeklyBudgetController controller, Color color, bool isExceeded) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimensions.height20 ?? 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            isExceeded ? 'BUDGET EXCEEDED' : 'ON TRACK',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontSize: Dimensions.font12,
            ),
          ),
          SizedBox(height: Dimensions.height10),
          Text(
            '₹${controller.spentAmount.value.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: Dimensions.font24 * 1.5,
              fontWeight: FontWeight.bold,
              color: AppColors.textColorPrimary,
            ),
          ),
          Text(
            'Spent this week',
            style: TextStyle(color: Colors.grey[600], fontSize: Dimensions.font14),
          ),
          SizedBox(height: Dimensions.height20),
          Divider(color: Colors.grey[100]),
          SizedBox(height: Dimensions.height10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat('Limit', '₹${controller.weeklyLimit.value.toStringAsFixed(0)}'),
              _buildStat(isExceeded ? 'Over by' : 'Saved', '₹${controller.remaining.abs().toStringAsFixed(0)}', color: color),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: Dimensions.font12)),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: Dimensions.font16,
            fontWeight: FontWeight.bold,
            color: color ?? AppColors.textColorPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(double progress, Color color) {
    return Container(
      height: 16,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(WeeklyBudgetController controller, bool isExceeded) {
    return Container(
      padding: EdgeInsets.all(Dimensions.height20),
      decoration: BoxDecoration(
        color: (isExceeded ? Colors.red : Colors.blue).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: (isExceeded ? Colors.red : Colors.blue).withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(
            isExceeded ? Icons.warning_amber_rounded : Icons.info_outline_rounded,
            color: isExceeded ? Colors.red : Colors.blue,
          ),
          SizedBox(width: Dimensions.width15),
          Expanded(
            child: Text(
              isExceeded 
                ? "You've spent ₹${controller.remaining.abs().toStringAsFixed(0)} more than your weekly target. Try to reduce non-essential expenses."
                : "Great job! You are ₹${controller.remaining.toStringAsFixed(0)} under your weekly limit. Keep it up!",
              style: TextStyle(
                fontSize: Dimensions.font14,
                color: isExceeded ? Colors.red[800] : Colors.blue[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
