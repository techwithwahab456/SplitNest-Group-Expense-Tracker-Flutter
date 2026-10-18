import 'package:expense_tracker_app/common/constant/app_enum.dart';
import 'package:flutter/material.dart';
import '../constant/app_colors.dart';


class AppHelper {
  /// Returns Green for "Owed" and Red for "Owe"
  static Color getStatusColor(DebtStatus status) {
    switch (status) {
      case DebtStatus.owed:
        return AppColors.owedColor;
      case DebtStatus.owe:
        return AppColors.oweColor;
      case DebtStatus.settled:
        return AppColors.lightGreyColor;
    }
  }

  /// Returns category-specific colors for Pie Charts
  static Color getCategoryColor(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food: return Colors.orange;
      case ExpenseCategory.transport: return Colors.blue;
      case ExpenseCategory.bills: return Colors.purple;
      case ExpenseCategory.entertainment: return Colors.pink;
      case ExpenseCategory.health: return Colors.red;
      case ExpenseCategory.shopping: return Colors.yellow;
      default: return AppColors.primaryTeal;
    }
  }

  /// Returns icon based on category
  
  IconData getCategoryIcon(String category) {
  switch (category.toLowerCase()) {
    case 'food': return Icons.restaurant;
    case 'shopping': return Icons.shopping_bag;
    case 'travel': return Icons.directions_car;
    case 'rent': return Icons.home;
    case 'fun': return Icons.movie;
    default: return Icons.receipt_long;
  }
}
}