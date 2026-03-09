import 'package:credit_debit/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Terms & Privacy', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.slate800)),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.slate800, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Privacy Policy',
              'Your privacy is important to us. It is our policy to respect your privacy regarding any information we may collect from you across our application.\n\n'
              'We only ask for personal information when we truly need it to provide a service to you. We collect it by fair and lawful means, with your knowledge and consent.',
            ),
            const SizedBox(height: 32),
            _buildSection(
              'Terms of Service',
              'By accessing our app, you are agreeing to be bound by these terms of service, all applicable laws and regulations, and agree that you are responsible for compliance with any applicable local laws.\n\n'
              'If you do not agree with any of these terms, you are prohibited from using or accessing this app. The materials contained in this app are protected by applicable copyright and trademark law.\n\n'
              'We reserve the right to review and amend any of these terms of service at our sole discretion.',
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.slate800)),
        const SizedBox(height: 16),
        Text(
          content,
          style: TextStyle(fontSize: 15, color: Colors.grey.shade700, height: 1.6),
        ),
      ],
    );
  }
}
