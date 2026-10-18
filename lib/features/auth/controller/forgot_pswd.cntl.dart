import 'dart:async';

import 'package:expense_tracker_app/datas/repositories/authrepository.dart';
import 'package:expense_tracker_app/features/home/views/bottomnavigationscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class VerifyCodeController extends GetxController {
  final _authRepo = Get.find<AuthRepository>();
  final isLoading = false.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    // Start checking for verification every 3 seconds automatically
    setTimerForAutoRedirect();
  }

  void setTimerForAutoRedirect() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        Get.offAll(() => const DashboardScreen());
      }
    });
  }

  Future<void> checkVerificationStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    if (user?.emailVerified ?? false) {
      Get.offAll(() => const DashboardScreen());
    } else {
      Get.snackbar('Not Verified', 'Please check your email and click the link.');
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}