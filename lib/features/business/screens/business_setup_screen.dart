import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/business_controller.dart';

class BusinessSetupScreen extends StatelessWidget {
  const BusinessSetupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BusinessController());

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Create Business', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dimensions.height20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Basic Information'),
            SizedBox(height: Dimensions.height15),
            _buildTextField(
              controller: controller.businessNameController,
              label: 'Business Name',
              hint: 'Enter business name',
              icon: Icons.business_outlined,
            ),
            SizedBox(height: Dimensions.height15),
            _buildDropdown(controller),
            
            SizedBox(height: Dimensions.height30),
            _buildSectionTitle('Financial Standards'),
            SizedBox(height: Dimensions.height15),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: controller.incomeController,
                    label: 'Std. Income',
                    hint: '0.00',
                    icon: Icons.account_balance_wallet_outlined,
                    keyboardType: TextInputType.number,
                    prefixText: '₹ ',
                  ),
                ),
                SizedBox(width: Dimensions.width15),
                Expanded(
                  child: _buildTextField(
                    controller: controller.investmentController,
                    label: 'Std. Investment',
                    hint: '0.00',
                    icon: Icons.trending_up_outlined,
                    keyboardType: TextInputType.number,
                    prefixText: '₹ ',
                  ),
                ),
              ],
            ),
            
            SizedBox(height: Dimensions.height30),
            _buildSectionTitle('Link Bank Accounts'),
            SizedBox(height: Dimensions.height10),
            _buildAccountSelector(controller),
            
            SizedBox(height: Dimensions.height45),
            _buildSubmitButton(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: Dimensions.font16,
        fontWeight: FontWeight.bold,
        color: AppColors.textColorPrimary.withValues(alpha: 0.8),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? prefixText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: AppColors.textColorSecondary, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.radius12),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.normal),
              prefixIcon: Icon(icon, color: AppColors.primaryColor, size: 20),
              prefixText: prefixText,
              prefixStyle: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(BusinessController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Business Type',
          style: TextStyle(fontSize: 14, color: AppColors.textColorSecondary, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.radius12),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          ),
          child: Obx(() => DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: controller.businessType.value,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: AppColors.textColorSecondary),
              items: controller.businessTypes.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: controller.setBusinessType,
            ),
          )),
        ),
      ],
    );
  }

  Widget _buildAccountSelector(BusinessController controller) {
    final accounts = ['HDFC Bank (...4212)', 'SBI Bank (...8890)', 'ICICI Bank (...1123)'];
    
    return Column(
      children: accounts.map((account) => Obx(() {
        final isSelected = controller.linkedAccounts.contains(account);
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor.withValues(alpha: 0.05) : Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.radius12),
            border: Border.all(
              color: isSelected ? AppColors.primaryColor : Colors.grey.withValues(alpha: 0.2),
            ),
          ),
          child: ListTile(
            leading: Icon(
              Icons.account_balance,
              color: isSelected ? AppColors.primaryColor : Colors.grey[400],
            ),
            title: Text(
              account,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primaryColor : AppColors.textColorPrimary,
              ),
            ),
            trailing: Checkbox(
              value: isSelected,
              activeColor: AppColors.primaryColor,
              onChanged: (_) => controller.toggleAccount(account),
            ),
            onTap: () => controller.toggleAccount(account),
          ),
        );
      })).toList(),
    );
  }

  Widget _buildSubmitButton(BusinessController controller) {
    return SizedBox(
      width: double.infinity,
      height: Dimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: controller.createBusiness,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius12),
          ),
          elevation: 0,
        ),
        child: Text(
          'Create Business',
          style: TextStyle(fontSize: Dimensions.font16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
