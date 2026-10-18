enum AppRole { user, admin }

/// Tracks if money is going out (Expense) or being settled (Settlement)
enum TransactionType { expense, settlement, adjustment }

/// Categories for BudgetBuddy
enum ExpenseCategory { food, transport, shopping, bills, entertainment, health, others }

/// Status of an expense in the "Swipe Room"
enum SwipeStatus { pending, accepted, rejected }

/// Debt relationship status
enum DebtStatus { owed, owe, settled }

/// Media categories for Firebase Storage paths
enum MediaCategory { profiles, groups, receipts, icons }

extension MediaCategoryExtension on MediaCategory {
  String get path {
    switch (this) {
      case MediaCategory.profiles: return 'users/profiles';
      case MediaCategory.groups: return 'groups/icons';
      case MediaCategory.receipts: return 'expenses/receipts';
      case MediaCategory.icons: return 'app/system_icons';
    }
  }
}