import 'package:expense_tracker_app/common/constant/app_enum.dart';
import 'package:intl/intl.dart';

class AppFormatter {
  /// Formats currency specifically for PKR (e.g., "PKR 2,500")
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_PK',
      symbol: 'PKR ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  /// Formats date for transaction history (e.g., "Dec 23, 2025")
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  /// Formats relative time for recent activity (e.g., "2 hours ago", "Yesterday")
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return formatDate(dateTime);
    }
  }

  /// Formats the "Split" summary (e.g., "Split between 4 people")
  static String formatSplitSummary(int count) {
    if (count <= 1) return "Paid by you";
    return "Split between $count people";
  }

  /// Returns text for debt status
  static String getDebtStatement(double amount, DebtStatus status) {
    String formattedAmount = formatCurrency(amount.abs());
    switch (status) {
      case DebtStatus.owed:
        return "You are owed $formattedAmount";
      case DebtStatus.owe:
        return "You owe $formattedAmount";
      case DebtStatus.settled:
        return "All settled up";
    }
  }
}