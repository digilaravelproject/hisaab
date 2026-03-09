import 'package:credit_debit/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Help & FAQ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.slate800)),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.slate800, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          _buildFaqItem('How do I add a new transaction?', 'Tap the plus (+) button on the Home or Dashboard screen to record a new income or expense entry.'),
          _buildFaqItem('Can I export my reports?', 'Yes, navigate to the Reports screen and tap the download icon. You can export data as PDF or Excel files.'),
          _buildFaqItem('How do I link a bank account?', 'Go to Settings > Add New Bank. Follow the instructions to securely link your bank for automatic syncing.'),
          _buildFaqItem('Is my data secure?', 'Absolutely. We use industry-standard encryption and optional biometric/PIN locks to keep your financial data private.'),
          _buildFaqItem('How do I set a budget?', 'In Settings, look for "Weekly Budget Limit" or "Monthly Budget Limit" to set your spending targets.'),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.slate800)),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedAlignment: Alignment.topLeft,
        children: [
          Text(answer, style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.5)),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
