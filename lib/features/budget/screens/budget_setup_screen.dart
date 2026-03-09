import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/budget_controller.dart';

class BudgetSetupScreen extends StatelessWidget {
  const BudgetSetupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BudgetController());

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Budget Setup', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.textColorPrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(Dimensions.height20),
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                return _buildCategoryItem(controller.categories[index], index);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(Dimensions.height20),
            child: _buildSaveButton(controller),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(BudgetCategory category, int index) {
    final TextEditingController textController = TextEditingController(
      text: category.targetAmount.value.toStringAsFixed(0),
    );

    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.height15),
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width15, vertical: Dimensions.height10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(category.icon, color: AppColors.primaryColor, size: 20),
          ),
          SizedBox(width: Dimensions.width15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: TextStyle(
                    fontSize: Dimensions.font16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColorPrimary,
                  ),
                ),
                Text(
                  'Monthly Target',
                  style: TextStyle(
                    fontSize: Dimensions.font12,
                    color: AppColors.textColorSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 100,
            child: TextField(
              controller: textController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: Dimensions.font16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
              decoration: InputDecoration(
                prefixText: '₹ ',
                prefixStyle: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
              onChanged: (value) {
                double? amount = double.tryParse(value);
                if (amount != null) {
                  category.targetAmount.value = amount;
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BudgetController controller) {
    return SizedBox(
      width: double.infinity,
      height: Dimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: controller.saveBudget,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
          ),
          elevation: 0,
        ),
        child: Text(
          'Save Budget',
          style: TextStyle(
            fontSize: Dimensions.font16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
