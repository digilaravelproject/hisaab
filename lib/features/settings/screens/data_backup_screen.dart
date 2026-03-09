import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/custom_snackbar.dart';

class DataBackupScreen extends StatelessWidget {
  const DataBackupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Data & Backup', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.slate800)),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.slate800, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Export Data'),
            const SizedBox(height: 12),
            _buildActionCard(
              icon: Icons.file_download_outlined,
              title: 'Export Transactions',
              subtitle: 'Download your data in CSV or PDF format',
              onTap: () => CustomSnackbar.showSuccess('Data export started...'),
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('Storage'),
            const SizedBox(height: 12),
            _buildActionCard(
              icon: Icons.delete_outline_rounded,
              title: 'Clear Cache',
              subtitle: 'Free up local storage space',
              onTap: () => CustomSnackbar.showSuccess('Cache cleared successfully'),
            ),
            const SizedBox(height: 16),
            _buildActionCard(
              icon: Icons.restart_alt_rounded,
              title: 'Reset App Data',
              subtitle: 'Wipe all local data and settings',
              isDanger: true,
              onTap: () => _showResetConfirmation(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade500, letterSpacing: 0.5),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDanger ? Colors.red.withOpacity(0.1) : AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: isDanger ? Colors.red : AppColors.primaryColor, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
        trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
      ),
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Reset All Data?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('This will delete all your transactions and bank links. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Future.delayed(const Duration(milliseconds: 300), () {
                CustomSnackbar.showSuccess('All data has been reset');
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Reset Now'),
          ),
        ],
      ),
    );
  }
}
