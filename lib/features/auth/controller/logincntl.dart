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

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  
  final isLoading = false.obs;
  final _authRepo = AuthRepository.instance;
  final _userRepo = UserRepository.instance;
  final _userController = Get.put(Usercontroller());
  var ispasswordvisible=false.obs;
  void tooglepasswordvisibility()=>ispasswordvisible.toggle();
  

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    
    isLoading.value = true;
    try {
      await _authRepo.loginWithEmailPassword(
        email: 
        emailController.text.trim(),
        password: 
        passwordController.text.trim(),
      );
      
      // Fetch user data into global controller
     await _userController.fetchuserrecord();
      
      Get.offAll(() => const DashboardScreen());
    } catch (e) {
      Get.snackbar('Login Failed', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> googleSignIn() async {
    isLoading.value = true;
    try {
      final userCredential = await _authRepo.signInWithGoogle();
      final firebaseUser = userCredential.user!;

      // Check if user already exists or create new
      final newUser = Usermodel(
        id: firebaseUser.uid,
        firstname: firebaseUser.displayName?.split(" ").first ?? '',
        lastname: firebaseUser.displayName?.split(" ").last ?? '',
        username: firebaseUser.email!.split("@").first,
        email: firebaseUser.email ?? '',
        profilepicture: firebaseUser.photoURL ?? "https://ui-avatars.com/api/?name=${firebaseUser.displayName}",
        phonenumber: firebaseUser.phoneNumber ?? '',
      );

      await _userRepo.saveUser(newUser);
      await _userController.fetchuserrecord();
      
      Get.offAll(() => const DashboardScreen());
    } catch (e) {
       Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}