import 'package:flutter/material.dart';
import 'package:credit_debit/core/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/dimensions.dart';
import '../../../routes/route_helper.dart';
import '../controllers/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Notifications', 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.slate800),
        ),
        centerTitle: false,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.slate800,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined, size: 22, color: AppColors.slate500),
            onPressed: () => controller.clearAll(),
            tooltip: 'Clear All',
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade100, height: 1),
        ),
      ),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text('No notifications yet', style: TextStyle(color: Colors.grey[500], fontSize: 16)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(Dimensions.height15),
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];
            return _buildNotificationCard(notification, controller);
          },
        );
      }),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification, NotificationController controller) {
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

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(Dimensions.radius15),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.red),
      ),
      onDismissed: (_) => controller.deleteNotification(notification.id),
      child: InkWell(
        onTap: () {
          controller.markAsRead(notification.id);
          Get.toNamed(RouteHelper.getNotificationDetailsRoute(), arguments: notification);
        },
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.white : Colors.blue.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: notification.isRead ? null : Border.all(color: AppColors.primaryColor.withValues(alpha: 0.1)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: getIconColor().withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(getIcon(), color: getIconColor(), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: notification.isRead ? AppColors.textColorPrimary : AppColors.primaryColor,
                  ),
                ),
                        Text(
                          _formatTime(notification.time),
                          style: TextStyle(color: Colors.grey[500], fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.message,
                      style: TextStyle(color: Colors.grey[700], fontSize: 13, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return DateFormat('MMM dd').format(time);
    }
  }
}
