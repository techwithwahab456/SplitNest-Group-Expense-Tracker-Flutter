import 'package:expense_tracker_app/datas/repositories/authrepository.dart';
import 'package:expense_tracker_app/datas/repositories/user_repository.dart';
import 'package:expense_tracker_app/features/auth/controller/usercontroller.dart';
import 'package:expense_tracker_app/features/home/views/bottomnavigationscreen.dart';
import 'package:expense_tracker_app/features/profile/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  final signUpFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final lastnameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordconfirmcontroller=TextEditingController();
  final phonenumberController = TextEditingController();

  final _userRepo = Get.put(UserRepository());
  final _authRepo = Get.put(AuthRepository());
  final _userController = Get.put(Usercontroller());

  var isPasswordVisible = false.obs;
  var isConfirmpasswordVisible=false.obs;
  final isLoading = false.obs;

  void signUp() async {
    try {
      if (!signUpFormKey.currentState!.validate()) return;

      isLoading.value = true;

      // 1. Create Account
      final userCredential = await _authRepo.signUpWithEmailPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // 2. Send Verification Email (Budget Buddy Global Security)
      await _authRepo.resendVerificationEmail();

      // 3. Generate Free Profile Picture URL
      String firstName = nameController.text.trim();
      String avatarUrl = "https://ui-avatars.com/api/?name=$firstName&background=0D8ABC&color=fff";

      // 4. Save User Record
      final newUser = Usermodel(
        id: userCredential.user!.uid,
        firstname: firstName,
        lastname: lastnameController.text.trim(),
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        phonenumber: phonenumberController.text.trim(),
        profilepicture: avatarUrl,
      );

      await _userRepo.saveUser(newUser);
      _userController.user.value = newUser;

      // 5. Navigate
      Get.offAll(() => const DashboardScreen());
      
      Get.snackbar('Verify Email', 'We have sent an email to ${emailController.text.trim()}. Please verify to use all features.',
          backgroundColor: Colors.blue, colorText: Colors.white, duration: const Duration(seconds: 5));

    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() => isPasswordVisible.toggle();
  void toggleConfirmPasswordvisibility()=>isConfirmpasswordVisible.toggle();
}