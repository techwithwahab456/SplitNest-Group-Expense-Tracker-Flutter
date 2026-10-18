import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/datas/repositories/friend_request_repository.dart';
import 'package:expense_tracker_app/features/auth/controller/usercontroller.dart';
import 'package:expense_tracker_app/features/find-friends/model/friend_request_model.dart';
import 'package:expense_tracker_app/features/profile/model/user_model.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';


class FriendRequestController extends GetxController {
  final _friendRepo = Get.find<FriendRepository>();
  final _currentUserId = Usercontroller.instance.user.value.id;

  Stream<List<FriendRequestModel>> get incomingRequests => 
      _friendRepo.getIncomingRequests(_currentUserId);

  void acceptFriend(FriendRequestModel request) async {
    await _friendRepo.updateRequestStatus(request.id, "accepted");
    // Extra: Add to a 'Friends' list logic here later
    Get.snackbar("Accepted", "You are now friends!");
  }
}
// class FriendshipController extends GetxController {
//   final _db = FirebaseFirestore.instance;
  
// // Use a getter to ensure we always have the latest user ID
//   String get currentUserId => Usercontroller.instance.user.value.id;

//   // 1. Send Request
//   Future<void> sendFriendRequest(Usermodel targetUser) async {
//     if (targetUser.id == currentUserId) {
//       Get.snackbar("Error", "You cannot add yourself!");
//       return;
//     }

//     try {
//       final currentUser = Usercontroller.instance.user.value;
      
//       await _db.collection("friend_requests").doc("${currentUserId}_${targetUser.id}").set({
//         'senderId': currentUserId,
//         'senderName': "${currentUser.firstname} ${currentUser.lastname}",
//         'senderEmail': currentUser.email,
//         'receiverId': targetUser.id,
//         'status': 'pending',
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//       Get.snackbar("Sent!", "Request sent to ${targetUser.firstname}");
//     } catch (e) {
//       Get.snackbar("Error", "Failed to send request: $e");
//     }
//   }

//   // 2. Stream of incoming requests
//   Stream<List<DocumentSnapshot>> getIncomingRequests() {
//     // We listen for documents where WE are the receiver
//     return _db.collection("friend_requests")
//         .where("receiverId", isEqualTo: currentUserId)
//         .where("status", isEqualTo: "pending")
//         .snapshots()
//         .map((snapshot) => snapshot.docs);
//   }

//   // 3. Accept Request
//   Future<void> acceptRequest(String requestId, String senderId) async {
//     // Logic: Update status to 'accepted' and add to a global 'Friends' list
//     await _db.collection("FriendRequests").doc(requestId).update({'status': 'accepted'});
    
//     // Add to Friends sub-collection for both users
//     await _db.collection("Users").doc(currentUserId).collection("Friends").doc(senderId).set({'addedAt': DateTime.now()});
//     await _db.collection("Users").doc(senderId).collection("Friends").doc(currentUserId).set({'addedAt': DateTime.now()});
    
//     Get.snackbar("Success", "You are now friends!");
//   }
// }