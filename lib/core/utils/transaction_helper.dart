import 'package:flutter/material.dart';

class TransactionHelper {
  static IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'utilities': return Icons.bolt_rounded;
      case 'services': return Icons.work_outline_rounded;
      case 'food': return Icons.restaurant_rounded;
      case 'salary': return Icons.payments_outlined;
      case 'grocery': return Icons.shopping_cart_rounded;
      case 'shopping': return Icons.shopping_bag_rounded;
      case 'transport': return Icons.local_gas_station_rounded;
      case 'travel': return Icons.flight_takeoff_rounded;
      case 'entertainment': return Icons.movie_outlined;
      case 'health': return Icons.medical_services_outlined;
      default: return Icons.category_outlined;
    }
  }
}
