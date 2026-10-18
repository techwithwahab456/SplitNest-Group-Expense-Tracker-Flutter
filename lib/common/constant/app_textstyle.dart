import 'package:expense_tracker_app/common/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  // BudgetBuddy Primary Styles
  static final TextStyle displayLarge = TextStyle(
    fontSize: 30.sp,
    fontWeight: FontWeight.w800,
    color: AppColors.whiteColor,
  );

  static final TextStyle amountLarge = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryTeal,
  );

  static final TextStyle headlineMedium = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.lightWhite,
  );

  // --- ADDED: headlineSmall ---
  static final TextStyle headlineSmall = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.whiteColor,
  );

  static final TextStyle bodyMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.lightGreyColor,
  );

  // --- ADDED: bodySmall ---
  static final TextStyle bodySmall = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.lightGreyColor,
  );

  static final TextStyle statusOwed = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.owedColor,
  );

  static final TextStyle statusOwe = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.oweColor,
  );

  static final TextStyle buttonText = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.blackColor,
  );
}