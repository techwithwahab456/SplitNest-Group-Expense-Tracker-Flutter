import 'dart:async';

import 'package:expense_tracker_app/datas/repositories/authrepository.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';

class PasswordRecoveryController extends GetxController {
  final emailController = TextEditingController();
  final emailError = RxnString();
  final isLoading = false.obs;
  
  // Timer Logic
  final remainingTime = 60.obs;
  final canResend = false.obs;
  Timer? _resendTimer;

  final AuthRepository _authRepo = Get.find<AuthRepository>();

  @override
  void onClose() {
    _resendTimer?.cancel();
    emailController.dispose();
    super.onClose();
  }

  void startResendTimer() {
    canResend.value = false;
    remainingTime.value = 60;
    _resendTimer?.cancel(); // Clear any existing timer
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  Future<void> sendResetLink() async {
    final email = emailController.text.trim();
    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Invalid Email', 'Please enter a valid email address');
      return;
    }

    isLoading.value = true;
    try {
      await _authRepo.sendPasswordResetEmail(email);
      Get.snackbar('Email Sent', 'Password reset link sent to $email',
          backgroundColor: Colors.green, colorText: Colors.white);
      startResendTimer();
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }
}