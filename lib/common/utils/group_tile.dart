import 'package:expense_tracker_app/common/constant/app_colors.dart';
import 'package:expense_tracker_app/common/utils/custom_container.dart';
import 'package:expense_tracker_app/common/utils/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GroupTile extends StatelessWidget {
  final String groupName;
  final String lastActivity;
  final double statusAmount;

  const GroupTile({super.key, required this.groupName, required this.lastActivity, required this.statusAmount});

  @override
  Widget build(BuildContext context) {
    bool isOwed = statusAmount > 0;
    return CustomContainer(
      elevation: 1,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.btngreyColor,
            child: TextWidget(text: groupName[0], color: AppColors.primaryTeal),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(text: groupName, textType: TextType.headlineMedium),
                TextWidget(text: lastActivity, textType: TextType.bodyMedium),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextWidget(
                text: "PKR ${statusAmount.abs().toStringAsFixed(0)}",
                textType: isOwed ? TextType.statusOwed : TextType.statusOwe,
              ),
              TextWidget(
                text: isOwed ? "you are owed" : "you owe",
                fontSize: 10.sp,
                color: AppColors.lightGreyColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}