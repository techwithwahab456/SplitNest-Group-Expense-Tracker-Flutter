import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppShadowStyle {
  /// Soft depth for general Cards (Dashboard/Group list)
  static final List<BoxShadow> cardShadow = [
    BoxShadow(
      color: AppColors.blackColor.withOpacity(0.3),
      blurRadius: 12.0,
      offset: const Offset(0, 6),
      spreadRadius: -2,
    ),
  ];

  /// Neon-style glow for "You are Owed" (Success/Green states)
  static final List<BoxShadow> successGlow = [
    BoxShadow(
      color: AppColors.owedColor.withOpacity(0.15),
      blurRadius: 20.0,
      offset: const Offset(0, 0),
      spreadRadius: 2,
    ),
  ];

  /// The Shadow used in your SwipeExpenseCard (Yellow/Pending glow)
  static final List<BoxShadow> swipeCardShadow = [
    BoxShadow(
      color: AppColors.pendingColor.withOpacity(0.12),
      blurRadius: 18.0,
      offset: const Offset(0, 10),
      spreadRadius: -2,
    ),
  ];

  /// The Shadow used in your CustomButton (Teal/Primary glow)
  static final List<BoxShadow> primaryBtnShadow = [
    BoxShadow(
      color: AppColors.primaryTeal.withOpacity(0.25),
      blurRadius: 12.0,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  /// Shadow for the bottom navigation bar or top bars
  static final List<BoxShadow> topShadow = [
    BoxShadow(
      color: AppColors.blackColor.withOpacity(0.2),
      blurRadius: 10.0,
      offset: const Offset(0, -4),
    ),
  ];
}