import 'package:expense_tracker_app/common/constant/app_colors.dart';
import 'package:expense_tracker_app/common/utils/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuddyChip extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const BuddyChip({
    super.key,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        margin: EdgeInsets.only(right: 10.w),
        decoration: BoxDecoration(
          // Teal background when selected, Grey surface when not
          color: isSelected ? AppColors.primaryTeal : AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryTeal : AppColors.btngreyColor,
            width: 1.5,
          ),
          // Add a tiny glow if selected
          boxShadow: isSelected 
              ? [BoxShadow(color: AppColors.primaryTeal.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))] 
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Icon(Icons.check, size: 16.sp, color: AppColors.blackColor),
              SizedBox(width: 6.w),
            ],
            TextWidget(
              text: name,
              // If selected, text is Black for contrast, else White/Grey
              color: isSelected ? AppColors.blackColor : AppColors.whiteColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 14.sp,
              textType: TextType.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}