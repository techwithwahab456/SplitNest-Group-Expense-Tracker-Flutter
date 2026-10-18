
import 'package:expense_tracker_app/common/constant/app_colors.dart';
import 'package:expense_tracker_app/common/utils/text_widget.dart';
import 'package:expense_tracker_app/features/auth/controller/usercontroller.dart';
import 'package:expense_tracker_app/features/profile/views/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
Widget buildHeader() {
  final userController = Usercontroller.instance; // Uses our global instance

  return GestureDetector(
    onTap: () => Get.to(() => const ProfileScreen()),
    child: Obx(() {
      final user = userController.user.value;
      
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                text: "Hello, ${user.firstname.isNotEmpty ? user.firstname : 'User'}!", 
                textType: TextType.headlineSmall
              ),
              TextWidget(
                text: "Here is your spending summary", 
                textType: TextType.bodySmall, 
                color: AppColors.lightGreyColor
              ),
            ],
          ),
          CircleAvatar(
            radius: 25.r,
            backgroundColor: AppColors.surfaceColor,
            backgroundImage: user.profilepicture.isNotEmpty 
                ? NetworkImage(user.profilepicture) 
                : null,
            child: user.profilepicture.isEmpty 
                ? Icon(Icons.person, color: AppColors.primaryTeal, size: 24.sp)
                : null,
          )
        ],
      );
    }),
  );
}