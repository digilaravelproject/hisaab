import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/home_controller.dart';
import 'package:intl/intl.dart';

class CustomerTile extends StatelessWidget {
  final Customer customer;
  final VoidCallback onTap;

  const CustomerTile({
    Key? key,
    required this.customer,
    required this.onTap,
  }) : super(key: key);

  String _formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(0)}';
  }

  String _timeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isYouWillGet = customer.balance > 0;
    final bool isYouWillGive = customer.balance < 0;
    final bool isSettled = customer.balance == 0;

    final Color statusColor = isYouWillGet
        ? Colors.green
        : isYouWillGive
            ? Colors.red
            : Colors.grey;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primaryColor.withOpacity(0.1),
              child: Text(
                customer.name.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Name & Time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    customer.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.slate800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        _timeAgo(customer.lastUpdated),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Balance amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatCurrency(customer.balance.abs()),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isSettled ? 'Settled' : (isYouWillGet ? 'You will get' : 'You will give'),
                  style: TextStyle(
                    fontSize: 11,
                    color: statusColor.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
