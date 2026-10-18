import 'package:expense_tracker_app/common/constant/app_colors.dart';
import 'package:expense_tracker_app/common/utils/custom_textfield.dart';
import 'package:expense_tracker_app/features/auth/controller/logincntl.dart';
import 'package:expense_tracker_app/features/auth/view/Forgot_passwod/forgotpassword_screen.dart';
import 'package:expense_tracker_app/features/auth/view/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:get/route_manager.dart';
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Get.put only if it's not already in memory, or use Get.find if initialized in bindings
    final controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              const Text("Welcome Back", 
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              const Text("Log in to track your shared expenses.", 
                style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),
              
              buildCustomTextField(
                controller: controller.emailController,
                label: "Email",
                icon: Icons.email_outlined,
                validator: (val) => GetUtils.isEmail(val!) ? null : "Enter a valid email",
              ),
              const SizedBox(height: 16),
              
              // FIX: Wrapped in Obx so the UI updates when visibility changes
            // Temporarily use the value inside Obx to stop the error
Obx(() {
  bool dummyWatcher = controller.ispasswordvisible.value; // Force GetX to watch
  return buildCustomTextField(
    controller: controller.passwordController,
    label: "Password",
    icon: Icons.lock_outline,
    isPassword: true,
    visibilityToggle: controller.ispasswordvisible,
  );
}),
              
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.to(() => const PasswordRecoveryView()), 
                  child: const Text("Forgot Password?", style: TextStyle(color: AppColors.primaryTeal))
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Loading state button
              Obx(() => buildPrimaryButton(
                text: "Login",
                isLoading: controller.isLoading.value,
                onPressed: () => controller.login(),
              )),
              
              const SizedBox(height: 30),
              const Center(child: Text("OR", style: TextStyle(color: Colors.grey))),
              const SizedBox(height: 30),
              
              // Google Login
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => controller.googleSignIn(),
                  icon: const Icon(Icons.g_mobiledata, size: 30, color: Colors.white),
                  label: const Text("Continue with Google", style: TextStyle(color: Colors.white)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () => Get.to(() => const SignUpView()),
                  child: const Text.rich(TextSpan(children: [
                    TextSpan(text: "New here? ", style: TextStyle(color: Colors.grey)),
                    TextSpan(text: "Create Account", style: TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
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