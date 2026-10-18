import 'package:expense_tracker_app/common/constant/app_colors.dart';
import 'package:expense_tracker_app/common/constant/app_shadow_style.dart';
import 'package:expense_tracker_app/common/utils/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SwipeExpenseCard extends StatelessWidget {
  final String title;
  final String payer;
  final double totalAmount;
  final double myShare; // Added this
  final String groupName; // Added this
  final IconData? icon;

  const SwipeExpenseCard({
    super.key,
    required this.title,
    required this.payer,
    required this.totalAmount,
    required this.myShare,
    required this.groupName,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.85.sw, 
      height: 0.55.sh, 
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: AppShadowStyle.swipeCardShadow,
        border: Border.all(color: Colors.white10, width: 1),
      ),
      child: Stack( // Added stack to show a "Group" badge
        children: [
          // 1. Top Badge for Group Name
          Positioned(
            top: 20.h,
            right: 20.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.primaryTeal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                groupName,
                style: TextStyle(color: AppColors.primaryTeal, fontSize: 10.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // 2. Main Content
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon Circle
                Container(
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: AppColors.bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon ?? Icons.payments_outlined, size: 50.sp, color: AppColors.primaryTeal),
                ),
                
                SizedBox(height: 20.h),
                
                TextWidget(
                  text: title, 
                  textType: TextType.displayLarge, 
                  fontSize: 24.sp,
                ),
                
                SizedBox(height: 4.h),
                
                TextWidget(
                  text: "Paid by $payer", 
                  textType: TextType.bodyMedium,
                  color: Colors.grey,
                ),
                
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 25.h),
                  child: Divider(color: Colors.white10, thickness: 1),
                ),
                
                // Show Your Share vs Total
                TextWidget(
                  text: "YOUR SHARE", 
                  textType: TextType.bodySmall,
                  color: AppColors.primaryTeal,
                ),
                TextWidget(
                  text: "PKR ${myShare.toStringAsFixed(0)}", 
                  textType: TextType.amountLarge,
                  fontSize: 36.sp,
                ),
                
                SizedBox(height: 10.h),
                
                Text(
                  "of PKR ${totalAmount.toStringAsFixed(0)} total",
                  style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}