import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../features/transactions/controllers/category_controller.dart';
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
                _showAttachmentOptions(context, tx, controller);
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
                  await controller.deleteTransaction(tx.id);
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
    final categoryController = Get.find<CategoryController>();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Change Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.slate800)),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (categoryController.categories.isEmpty) {
                  return const Center(child: Text('No categories available'));
                }
                
                return GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemCount: categoryController.categories.length,
                  itemBuilder: (context, index) {
                    final category = categoryController.categories[index];
                    final isSelected = tx.categoryId == category.id;
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        controller.categorizeTransaction(tx.id, category.id, businessId: tx.businessId);
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
                            Icon(TransactionHelper.getCategoryIcon(category.name), color: isSelected ? AppColors.primaryColor : AppColors.slate500),
                            const SizedBox(height: 8),
                            Text(
                              category.name,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? AppColors.primaryColor : AppColors.slate500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  static void _showAttachmentOptions(BuildContext context, TransactionModel tx, TransactionController controller) {
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
                controller.pickAndUploadReceipt(tx.id, source: ImageSource.camera);
              },
            ),
            _buildActionItem(
              icon: Icons.image_outlined,
              label: 'Upload from Gallery',
              onTap: () {
                Navigator.pop(context);
                controller.pickAndUploadReceipt(tx.id, source: ImageSource.gallery);
              },
            ),
            _buildActionItem(
              icon: Icons.picture_as_pdf_outlined,
              label: 'Upload PDF / Document',
              onTap: () {
                Navigator.pop(context);
                controller.pickAndUploadReceipt(tx.id, isPdf: true);
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
