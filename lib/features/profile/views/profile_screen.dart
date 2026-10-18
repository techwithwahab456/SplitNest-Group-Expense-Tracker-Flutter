import 'package:expense_tracker_app/common/constant/app_colors.dart';
import 'package:expense_tracker_app/common/utils/custom_textfield.dart';
import 'package:expense_tracker_app/datas/repositories/authrepository.dart';
import 'package:expense_tracker_app/features/auth/controller/usercontroller.dart';
import 'package:expense_tracker_app/features/profile/views/edit_profile_Screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Usercontroller.instance;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => AuthRepository.instance.logout(),
            icon: const Icon(Icons.logout, color: Colors.redAccent),
          )
        ],
      ),
      body: Obx(() {
        if (userController.profileloading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal));
        }

        final user = userController.user.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Profile Picture Section
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.primaryTeal,
                      backgroundImage: user.profilepicture.isNotEmpty 
                          ? NetworkImage(user.profilepicture) 
                          : null,
                      child: user.profilepicture.isEmpty 
                          ? Text(user.firstname[0].toUpperCase(), style: const TextStyle(fontSize: 40, color: Colors.white))
                          : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text("${user.firstname} ${user.lastname}", 
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              Text("@${user.username}", style: const TextStyle(color: Colors.grey)),
              
              const SizedBox(height: 30),
              const Divider(color: Colors.grey),
              const SizedBox(height: 10),

              // User Details List
              _buildProfileTile(Icons.email, "Email", user.email),
              _buildProfileTile(Icons.phone, "Phone", user.phonenumber),
              
              const SizedBox(height: 40),
              
              // Example of a button to edit (Optional)
              buildPrimaryButton(
                text: "Edit Profile", 
                onPressed: () {
                  Get.to(()=>EditProfileScreen());
                }
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryTeal),
      title: Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      subtitle: Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
    );
  }
}