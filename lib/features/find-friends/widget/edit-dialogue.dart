import 'package:expense_tracker_app/common/constant/app_colors.dart';
import 'package:expense_tracker_app/common/utils/custom_textfield.dart';
import 'package:expense_tracker_app/datas/repositories/group_repository.dart';
import 'package:expense_tracker_app/features/friends_group/model/group_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

void showEditDialog(BuildContext context, GroupModel group) {
  final nameController = TextEditingController(text: group.groupName);
  Get.defaultDialog(
    title: "Edit Group Name",
    backgroundColor: AppColors.surfaceColor,
    titleStyle: const TextStyle(color: Colors.white),
    content: buildCustomTextField(controller: nameController, label: "New Name", icon: Icons.edit),
    confirm: TextButton(
      onPressed: () {
        GroupRepository.instance.updateGroupName(group.id, nameController.text);
        Get.back();
      },
      child: const Text("Save", style: TextStyle(color: AppColors.primaryTeal)),
    ),
  );
}