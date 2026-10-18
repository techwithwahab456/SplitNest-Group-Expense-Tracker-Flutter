import 'package:expense_tracker_app/common/constant/app_colors.dart';
import 'package:expense_tracker_app/common/utils/custom_textfield.dart';
import 'package:expense_tracker_app/features/auth/controller/sign_up_cntl.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        iconTheme: const IconThemeData(color: Colors.white)
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: controller.signUpFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Create Account", 
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              const Text("Join Budget Buddy and start splitting bills globally.", 
                style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 30),
              
              // First & Last Name Row
              Row(
                children: [
                  Expanded(child: buildCustomTextField(
                    controller: controller.nameController, 
                    label: "First Name", 
                    icon: Icons.person_outline
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: buildCustomTextField(
                    controller: controller.lastnameController, 
                    label: "Last Name", 
                    icon: Icons.person_outline
                  )),
                ],
              ),
              const SizedBox(height: 16),

              buildCustomTextField(
                controller: controller.usernameController, 
                label: "Username", 
                icon: Icons.alternate_email
              ),
              const SizedBox(height: 16),

              buildCustomTextField(
                controller: controller.emailController, 
                label: "Email", 
                icon: Icons.email_outlined,
                validator: (val) => GetUtils.isEmail(val!) ? null : "Invalid Email",
              ),
              const SizedBox(height: 16),

              buildCustomTextField(
                controller: controller.phonenumberController, 
                label: "Phone", 
                icon: Icons.phone_android
              ),
              const SizedBox(height: 16),

              buildCustomTextField(
                controller: controller.passwordController, 
                label: "Password", 
                icon: Icons.lock_outline, 
                isPassword: true, 
                visibilityToggle: controller.isPasswordVisible
              ),
              const SizedBox(height: 16),

              // Confirm Password
              buildCustomTextField(
                
                controller: controller.passwordconfirmcontroller, 
                label: "Confirm Password", 
                icon: Icons.verified_user_outlined, 
                isPassword: true, 
                visibilityToggle: controller.isConfirmpasswordVisible, // Reusing same toggle for simplicity
                validator: (val) => val != controller.passwordController.text ? "Passwords do not match" : null,
              ),
              
              const SizedBox(height: 30),
              Obx(() => buildPrimaryButton(
                text: "Create Account",
                isLoading: controller.isLoading.value,
                onPressed: () => controller.signUp(),
              )),
              
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: const Text.rich(TextSpan(children: [
                    TextSpan(text: "Already have an account? ", style: TextStyle(color: Colors.grey)),
                    TextSpan(text: "Login", style: TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                  ])),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}