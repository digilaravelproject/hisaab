import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/cash_entry_controller.dart';

class CashEntryScreen extends StatelessWidget {
  const CashEntryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CashEntryController());

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('New Cash Entry', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.textColorPrimary,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dimensions.height20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Credit/Debit Toggle
            _buildToggleSection(controller),
            SizedBox(height: Dimensions.height30),

            // Amount Input
            _buildAmountSection(controller),
            SizedBox(height: Dimensions.height30),

            // Date Picker
            _buildDateSection(context, controller),
            SizedBox(height: Dimensions.height20),

            // Purpose Dropdown
            _buildPurposeSection(controller),
            SizedBox(height: Dimensions.height20),

            // Business/Personal Toggle
            _buildEntitySection(controller),
            SizedBox(height: Dimensions.height45),

            // Save Button
            _buildSaveButton(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleSection(CashEntryController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transaction Type',
          style: TextStyle(
            fontSize: Dimensions.font14,
            fontWeight: FontWeight.w600,
            color: AppColors.textColorSecondary,
          ),
        ),
        SizedBox(height: Dimensions.height10),
        Obx(() => Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(Dimensions.radius12),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.toggleType(true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: controller.isCredit.value ? AppColors.successColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(Dimensions.radius12),
                    ),
                    child: Center(
                      child: Text(
                        'CREDIT',
                        style: TextStyle(
                          color: controller.isCredit.value ? Colors.white : AppColors.textColorSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.toggleType(false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: !controller.isCredit.value ? AppColors.errorColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(Dimensions.radius12),
                    ),
                    child: Center(
                      child: Text(
                        'DEBIT',
                        style: TextStyle(
                          color: !controller.isCredit.value ? Colors.white : AppColors.textColorSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildAmountSection(CashEntryController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter Amount',
          style: TextStyle(
            fontSize: Dimensions.font14,
            fontWeight: FontWeight.w600,
            color: AppColors.textColorSecondary,
          ),
        ),
        SizedBox(height: Dimensions.height10),
        TextField(
          onChanged: controller.updateAmount,
          keyboardType: TextInputType.number,
          style: TextStyle(
            fontSize: Dimensions.font24 * 1.5,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
          decoration: InputDecoration(
            prefixText: '\$ ',
            hintText: '0.00',
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSection(BuildContext context, CashEntryController controller) {
    return InkWell(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: controller.selectedDate.value,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (picked != null) controller.updateDate(picked);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date',
            style: TextStyle(
              fontSize: Dimensions.font14,
              fontWeight: FontWeight.w600,
              color: AppColors.textColorSecondary,
            ),
          ),
          SizedBox(height: Dimensions.height10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(Dimensions.radius12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(
                  DateFormat('MMMM dd, yyyy').format(controller.selectedDate.value),
                  style: TextStyle(fontSize: Dimensions.font16),
                )),
                Icon(Icons.calendar_today, color: AppColors.primaryColor, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurposeSection(CashEntryController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category/Purpose',
          style: TextStyle(
            fontSize: Dimensions.font14,
            fontWeight: FontWeight.w600,
            color: AppColors.textColorSecondary,
          ),
        ),
        SizedBox(height: Dimensions.height10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(Dimensions.radius12),
          ),
          child: Obx(() => DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: controller.selectedPurpose.value,
              isExpanded: true,
              items: controller.purposes.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: controller.updatePurpose,
            ),
          )),
        ),
      ],
    );
  }

  Widget _buildEntitySection(CashEntryController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Business Transaction?',
          style: TextStyle(
            fontSize: Dimensions.font16,
            fontWeight: FontWeight.w500,
            color: AppColors.textColorPrimary,
          ),
        ),
        Obx(() => Switch(
          value: controller.isBusiness.value,
          onChanged: controller.toggleEntity,
          activeColor: AppColors.primaryColor,
        )),
      ],
    );
  }

  Widget _buildSaveButton(CashEntryController controller) {
    return SizedBox(
      width: double.infinity,
      height: Dimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: controller.saveTransaction,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
          ),
          elevation: 0,
        ),
        child: Text(
          'Save Entry',
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
