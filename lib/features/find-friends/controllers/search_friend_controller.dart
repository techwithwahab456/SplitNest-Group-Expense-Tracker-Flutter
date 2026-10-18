import 'package:expense_tracker_app/datas/repositories/friend_request_repository.dart';
import 'package:expense_tracker_app/datas/repositories/group_repository.dart';
import 'package:expense_tracker_app/datas/repositories/user_repository.dart';
import 'package:expense_tracker_app/features/auth/controller/usercontroller.dart';
import 'package:expense_tracker_app/features/find-friends/model/friend_request_model.dart';
import 'package:expense_tracker_app/features/friends_group/model/group_model.dart';
import 'package:expense_tracker_app/features/profile/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SocialHubController extends GetxController {
  final searchController = TextEditingController();
  final rxFoundUser = Rxn<Usermodel>();
  final isLoading = false.obs;
  final _groupRepo = Get.put(GroupRepository());

  // Repositories
  final _userRepo = Get.find<UserRepository>();
  final _friendRepo = Get.put(FriendRepository());
  
  // Current User ID for streams
  String get currentUserId => Usercontroller.instance.user.value.id;

  // Search Logic (Integrated from your FriendSearchController)
  // ... (Existing variables)
  final rxIsAlreadyFriend = false.obs;
  final _cachedFriends = <Usermodel>[].obs;
List<Usermodel> get cachedFriends => _cachedFriends;
 @override
  void onInit() {
    super.onInit();
    // Listen to friends stream and update cache
    myFriends.listen((friends) {
      _cachedFriends.assignAll(friends);
    });
  }

  void searchUser() async {
    if (searchController.text.isEmpty) {
      rxFoundUser.value = null;
      return;
    }
    isLoading.value = true;
    try {
      final user = await _userRepo.getUserByEmail(searchController.text.trim());
      rxFoundUser.value = user;

      if (user != null) {
        // CHECK: Is this user already in our friends list?
        rxIsAlreadyFriend.value = await _friendRepo.checkIfAlreadyFriends(currentUserId, user.id);
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Send Request Logic
  void processSendRequest() async {
    final targetUser = rxFoundUser.value;
    final currentUser = Usercontroller.instance.user.value;

    if (targetUser == null) return;
    if (targetUser.id == currentUser.id) {
      Get.snackbar("Error", "You can't add yourself.");
      return;
    }

    final newRequest = FriendRequestModel(
      id: "", 
      senderId: currentUser.id,
      senderName: "${currentUser.firstname} ${currentUser.lastname}",
      senderEmail: currentUser.email,
      receiverId: targetUser.id,
      status: "pending",
    );

    await _friendRepo.sendFriendRequest(newRequest);
    rxFoundUser.value = null; // Clear search result after sending
    searchController.clear();
    Get.snackbar("Success", "Request sent to ${targetUser.firstname}");
  }

  // Stream for the Friends List
  Stream<List<Usermodel>> get myFriends => _friendRepo.getFriendsList(currentUserId);
  Stream<List<GroupModel>> get myGroups => _groupRepo.getActiveGroups(currentUserId);
  Stream<List<GroupModel>> get groupInvites => _groupRepo.getPendingGroupInvites(currentUserId);

  void acceptGroup(String groupId) async {
    await _groupRepo.acceptGroupInvite(groupId, currentUserId);
    Get.snackbar("Success", "Joined group!");
  }
}