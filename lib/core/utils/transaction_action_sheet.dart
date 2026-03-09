import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/transactions/controllers/transaction_controller.dart';
import '../../features/transactions/screens/transactions_screen.dart';
import '../theme/app_colors.dart';
import '../../routes/route_helper.dart';
import 'custom_snackbar.dart';
import 'transaction_helper.dart';

class TransactionActionSheet {
  static void show(BuildContext context, TransactionModel tx) {
    final TransactionController controller = Get.find<TransactionController>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 20),
            _buildActionItem(
              icon: Icons.edit_outlined,
              label: 'Edit Transaction',
              onTap: () {
                Navigator.pop(context);
                Get.toNamed(RouteHelper.getAddEntryRoute(), arguments: {
                  'transaction': tx,
                });
              },
            ),
            _buildActionItem(
              icon: Icons.category_outlined,
              label: 'Change Category',
              onTap: () {
                Navigator.pop(context);
                _showCategoryPicker(context, tx, controller);
              },
            ),
            _buildActionItem(
              icon: Icons.attach_file_rounded,
              label: 'Attach Bill / Receipt',
              onTap: () {
                Navigator.pop(context);
                _showAttachmentOptions(context, tx);
              },
            ),
            Container(height: 1, color: AppColors.slate100, margin: const EdgeInsets.symmetric(vertical: 20)),
            _buildActionItem(
              icon: Icons.delete_outline_rounded,
              label: 'Delete Transaction',
              color: Colors.red,
              onTap: () async {
                Navigator.pop(context);
                if (await confirmDelete(context)) {
                  controller.deleteTransaction(tx.id);
                  CustomSnackbar.showSuccess('Transaction deleted');
                }
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  static void _showCategoryPicker(BuildContext context, TransactionModel tx, TransactionController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Change Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.slate800)),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: controller.categories.length - 1, // Exclude 'All'
              itemBuilder: (context, index) {
                final category = controller.categories.where((c) => c != 'All').elementAt(index);
                final isSelected = tx.category == category;
                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    // In a real app, update the transaction category here via controller
                    CustomSnackbar.showSuccess('Category updated to $category');
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryColor.withOpacity(0.1) : AppColors.slate100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSelected ? AppColors.primaryColor : Colors.transparent),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(TransactionHelper.getCategoryIcon(category), color: isSelected ? AppColors.primaryColor : AppColors.slate500),
                        const SizedBox(height: 8),
                        Text(
                          category,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? AppColors.primaryColor : AppColors.slate500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static void _showAttachmentOptions(BuildContext context, TransactionModel tx) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Attach File', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.slate800)),
            const SizedBox(height: 20),
            _buildActionItem(
              icon: Icons.camera_alt_outlined,
              label: 'Take Photo',
              onTap: () {
                Navigator.pop(context);
                CustomSnackbar.showInfo('Opening camera...');
              },
            ),
            _buildActionItem(
              icon: Icons.image_outlined,
              label: 'Upload from Gallery',
              onTap: () {
                Navigator.pop(context);
                CustomSnackbar.showInfo('Opening gallery...');
              },
            ),
            _buildActionItem(
              icon: Icons.picture_as_pdf_outlined,
              label: 'Upload PDF / Document',
              onTap: () {
                Navigator.pop(context);
                CustomSnackbar.showInfo('Opening file manager...');
              },
            ),
          ],
        ),
      ),
    );
  }

  static Future<bool> confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction?'),
        content: const Text('Are you sure you want to permanently delete this record?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      )
    ) ?? false;
  }

  static Widget _buildActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = AppColors.slate800,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: color)),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20, color: Colors.grey),
      onTap: onTap,
    );
  }
}
