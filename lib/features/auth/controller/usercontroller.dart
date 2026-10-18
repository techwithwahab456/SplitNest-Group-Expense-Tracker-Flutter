import 'package:expense_tracker_app/datas/repositories/authrepository.dart';
import 'package:expense_tracker_app/datas/repositories/user_repository.dart';
import 'package:expense_tracker_app/features/profile/model/user_model.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class Usercontroller extends GetxController {
  static Usercontroller get instance => Get.put(Usercontroller());

  Rx<Usermodel> user = Usermodel.empty().obs;
  final profileloading = false.obs;
  final _userRepo = Get.put(UserRepository());

  @override
  void onInit() {
    super.onInit();
    fetchuserrecord();
  }

  Future<void> fetchuserrecord() async {
    try {
      profileloading.value = true;
      
      // Get current logged in UID
      final uid = AuthRepository.instance.currentUser?.uid;
      if (uid == null) return;

      final userData = await _userRepo.fetchUserData(uid);
      user.value = userData;
    } catch (e) {
      user.value = Usermodel.empty();
    } finally {
      profileloading.value = false;
    }
  }

  Future<void> updateName(String firstName, String lastName) async {
    try {
      user.value.firstname = firstName;
      user.value.lastname = lastName;
      
      await _userRepo.updateUserData(user.value);
      user.refresh(); // Tell GetX that the object internal values changed
      
      Get.snackbar('Success', 'Profile updated');
    } catch (e) {
      Get.snackbar('Error', 'Could not update name');
    }
  }
}