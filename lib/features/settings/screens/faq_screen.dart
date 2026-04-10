import 'package:credit_debit/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../help_support/controllers/help_support_controller.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final controller = Get.find<HelpAndSupportController>();

  @override
  void initState() {
    super.initState();
    controller.fetchPage('/api/v1/static/faqs');
  }

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
      body: Obx(() {
        if (controller.isLoading.value && controller.faqItems.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.faqItems.isEmpty) {
          return const Center(child: Text('No FAQs found'));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          itemCount: controller.faqItems.length,
          itemBuilder: (context, index) {
            final item = controller.faqItems[index];
            return _buildFaqItem(item['question'] ?? '', item['answer'] ?? '');
          },
        );
      }),
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
