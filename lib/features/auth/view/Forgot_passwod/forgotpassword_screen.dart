import 'package:expense_tracker_app/common/constant/app_colors.dart';
import 'package:expense_tracker_app/common/utils/custom_textfield.dart';
import 'package:expense_tracker_app/features/auth/controller/otp_cntl.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class PasswordRecoveryView extends StatelessWidget {
  const PasswordRecoveryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PasswordRecoveryController());

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.white)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lock_reset, size: 80, color: AppColors.primaryTeal),
            const SizedBox(height: 20),
            const Text("Forgot Password?", 
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            const Text("Enter your email and we will send you a link to reset your password safely.", 
              style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 40),
            
            buildCustomTextField(
              controller: controller.emailController, 
              label: "Email Address", 
              icon: Icons.email_outlined
            ),
            
            const SizedBox(height: 30),
            
            Obx(() => buildPrimaryButton(
              text: "Send Reset Link",
              isLoading: controller.isLoading.value,
              onPressed: () => controller.sendResetLink(),
            )),
            
            const SizedBox(height: 20),
            
            // Resend Timer UI
            Obx(() => Center(
              child: controller.canResend.value 
                ? TextButton(
                    onPressed: () => controller.sendResetLink(), 
                    child: const Text("Resend Link", style: TextStyle(color: AppColors.primaryTeal))
                  )
                : Text("Resend link in ${controller.remainingTime.value}s", 
                    style: const TextStyle(color: Colors.grey)),
            )),
          ],
        ),
      ),
    );
  }
}