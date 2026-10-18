import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense_tracker_app/common/constant/app_colors.dart';
import 'package:expense_tracker_app/common/utils/text_widget.dart';

class SwipeActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const SwipeActionButton({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 64.h,
            width: 64.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceColor,
              border: Border.all(color: color.withOpacity(0.5), width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.15),
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Icon(icon, color: color, size: 28.sp),
          ),
          SizedBox(height: 10.h),
          TextWidget(
            text: label, 
            textType: TextType.bodyMedium, 
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}