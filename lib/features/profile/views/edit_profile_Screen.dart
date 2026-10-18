import 'package:expense_tracker_app/common/constant/app_colors.dart';
import 'package:expense_tracker_app/common/utils/custom_textfield.dart';
import 'package:expense_tracker_app/features/auth/controller/usercontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final controller = Usercontroller.instance;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  final isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    // Pre-fill controllers with current user data
    firstNameController = TextEditingController(text: controller.user.value.firstname);
    lastNameController = TextEditingController(text: controller.user.value.lastname);
  }

  Future<void> saveProfile() async {
    try {
      isLoading.value = true;
      await controller.updateName(
        firstNameController.text.trim(), 
        lastNameController.text.trim()
      );
      Get.back(); // Return to Profile Screen
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Profile Picture Preview
            Obx(() => CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.surfaceColor,
              backgroundImage: controller.user.value.profilepicture.isNotEmpty 
                  ? NetworkImage(controller.user.value.profilepicture) 
                  : null,
              child: controller.user.value.profilepicture.isEmpty 
                  ? const Icon(Icons.person, size: 50, color: AppColors.primaryTeal)
                  : null,
            )),
            const SizedBox(height: 30),

            buildCustomTextField(
              controller: firstNameController,
              label: "First Name",
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),

            buildCustomTextField(
              controller: lastNameController,
              label: "Last Name",
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 30),

            Obx(() => buildPrimaryButton(
              text: "Save Changes",
              isLoading: isLoading.value,
              onPressed: saveProfile,
            )),
          ],
        ),
      ),
    );
  }
}