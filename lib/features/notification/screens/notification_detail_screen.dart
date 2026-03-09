import 'package:flutter/material.dart';
import 'package:credit_debit/core/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/notification_controller.dart';

class NotificationDetailScreen extends StatelessWidget {
  const NotificationDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Safely get arguments
    final NotificationItem? notification = Get.arguments is NotificationItem ? Get.arguments : null;
    
    if (notification == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Notification details not found.')),
      );
    }
    
    final controller = Get.find<NotificationController>();

    Color getIconColor() {
      switch (notification.type) {
        case NotificationType.info: return Colors.blue;
        case NotificationType.warning: return Colors.orange;
        case NotificationType.success: return Colors.green;
      }
    }

    IconData getIcon() {
      switch (notification.type) {
        case NotificationType.info: return Icons.info_outline;
        case NotificationType.warning: return Icons.warning_amber_rounded;
        case NotificationType.success: return Icons.check_circle_outline;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Notification Details', 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.slate800)
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.slate800,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade100, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: getIconColor().withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(getIcon(), color: getIconColor(), size: 48),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              notification.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textColorPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('EEEE, MMM dd, yyyy • hh:mm a').format(notification.time),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            Text(
              notification.message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade800,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Back to Notifications',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
