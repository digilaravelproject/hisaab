import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/custom_snackbar.dart';

class AddBankScreen extends StatelessWidget {
  const AddBankScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Add Bank Account'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Select Bank', border: OutlineInputBorder()),
              items: ['HDFC Bank', 'ICICI Bank', 'SBI', 'Axis Bank'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) {},
            ),
            const SizedBox(height: 16),
            TextFormField(decoration: const InputDecoration(labelText: 'Account Holder Name', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextFormField(decoration: const InputDecoration(labelText: 'Account Number', border: OutlineInputBorder()), keyboardType: TextInputType.number),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  CustomSnackbar.showSuccess('New bank account linked successfully');
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor, padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('Link Account', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
