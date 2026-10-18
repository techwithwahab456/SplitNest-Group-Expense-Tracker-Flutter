import 'package:expense_tracker_app/common/constant/app_colors.dart';
import 'package:expense_tracker_app/features/auth/controller/usercontroller.dart';
import 'package:expense_tracker_app/features/find-friends/controllers/friend_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart'; import 'package:expense_tracker_app/common/constant/app_colors.dart';
import 'package:expense_tracker_app/features/find-friends/controllers/friend_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Removed BuildContext requirement from parameters since we use Get.context
void showSettleDialog(FriendDetailController controller, double amount) {
  final String friendName = controller.friend.firstname;

  Get.defaultDialog(
    backgroundColor: AppColors.surfaceColor,
    title: "Confirm Received",
    titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    middleText: "Are you sure you received PKR ${amount.toStringAsFixed(0)} in cash from $friendName?",
    middleTextStyle: const TextStyle(color: Colors.grey),
    textConfirm: "Yes, Received",
    confirmTextColor: Colors.black,
    buttonColor: AppColors.primaryTeal,
    onConfirm: () {
      controller.settleDebt(amount);
      if (Get.isDialogOpen!) Get.back(); // Closes the dialog
    },
    textCancel: "Cancel",
    cancelTextColor: Colors.white,
  );
}