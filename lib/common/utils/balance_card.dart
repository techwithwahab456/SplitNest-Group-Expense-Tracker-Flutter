import 'package:expense_tracker_app/common/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/common/constant/app_colors.dart';
import 'package:expense_tracker_app/common/constant/app_shadow_style.dart';
import 'package:expense_tracker_app/common/utils/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BalanceCard extends StatelessWidget {
  final String title;
  final String amount;
  final bool isOwed; // True = Green (Owed), False = Red (Owe)

  const BalanceCard({
    super.key, 
    required this.title, 
    required this.amount, 
    required this.isOwed
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: isOwed ? AppShadowStyle.successGlow : AppShadowStyle.cardShadow,
        border: Border.all(
          color: isOwed ? AppColors.owedColor.withOpacity(0.5) : AppColors.oweColor.withOpacity(0.5), 
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: title, 
            textType: isOwed ? TextType.statusOwed : TextType.statusOwe,
          ),
          SizedBox(height: 12.h),
          TextWidget(
            text: "PKR $amount", 
            textType: TextType.amountLarge,
            color: isOwed ? AppColors.owedColor : AppColors.oweColor,
          ),
        ],
      ),
    );
  }
}