import 'package:expense_tracker_app/common/constant/app_colors.dart';
import 'package:expense_tracker_app/common/utils/custom_textfield.dart';
import 'package:expense_tracker_app/datas/repositories/authrepository.dart';
import 'package:expense_tracker_app/features/auth/controller/forgot_pswd.cntl.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class EmailVerificationView extends StatelessWidget {
  const EmailVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyCodeController());

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mark_email_unread_outlined, size: 100, color: AppColors.primaryTeal),
            const SizedBox(height: 30),
            const Text("Verify your Email", 
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),
            const Text(
              "We have sent a verification link to your email. Click the link to activate your account and start splitting bills!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            buildPrimaryButton(
              text: "I have verified", 
              onPressed: () => controller.checkVerificationStatus()
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => AuthRepository.instance.resendVerificationEmail(), 
              child: const Text("Resend Email Link", style: TextStyle(color: AppColors.primaryTeal))
            ),
          ],
        ),
      ),
    );
  }
}