import 'package:expense_tracker_app/common/constant/app_colors.dart';
import 'package:expense_tracker_app/common/utils/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FullScreenLoader {
  static void show({String? message}) {
    if (Get.isDialogOpen == true) return;

    Get.dialog(
      PopScope(
        canPop: false, // Updated from WillPopScope for Flutter 3.x
        child: Scaffold(
          backgroundColor: AppColors.bgColor.withOpacity(0.85),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryTeal),
                ),
                SizedBox(height: 25.h),
                TextWidget(
                  text: message ?? "Processing...",
                  textType: TextType.bodyMedium,
                  color: AppColors.whiteColor,
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hide() => Get.isDialogOpen == true ? Get.back() : null;
}