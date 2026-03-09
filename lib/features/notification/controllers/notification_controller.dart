import 'package:get/get.dart';
import 'package:flutter/material.dart';

enum NotificationType { info, warning, success }

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime time;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.time,
    this.isRead = false,
  });
}

class NotificationController extends GetxController {
  final notifications = <NotificationItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockNotifications();
  }

  void _loadMockNotifications() {
    notifications.assignAll([
      NotificationItem(
        id: '1',
        title: 'Daily Reminder',
        message: 'Don\'t forget to record your daily farm expenses.',
        type: NotificationType.info,
        time: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      NotificationItem(
        id: '2',
        title: 'Limit Exceeded!',
        message: 'You have exceeded your weekly budget for "Utilities" by ₹500.',
        type: NotificationType.warning,
        time: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      NotificationItem(
        id: '3',
        title: 'Weekly Budget Update',
        message: 'Your weekly budget for "Fertilizers" has been successfully set.',
        type: NotificationType.success,
        time: DateTime.now().subtract(const Duration(days: 1)),
      ),
      NotificationItem(
        id: '4',
        title: 'System Alert',
        message: 'Your bank account ending in **1234 has been synced.',
        type: NotificationType.info,
        time: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ]);
  }

  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final old = notifications[index];
      notifications[index] = NotificationItem(
        id: old.id,
        title: old.title,
        message: old.message,
        type: old.type,
        time: old.time,
        isRead: true,
      );
    }
  }

  void clearAll() {
    notifications.clear();
  }

  void deleteNotification(String id) {
    notifications.removeWhere((n) => n.id == id);
  }
}
