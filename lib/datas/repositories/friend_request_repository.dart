import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/features/find-friends/model/friend_request_model.dart';
import 'package:expense_tracker_app/features/profile/model/user_model.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class FriendRepository extends GetxController {
  static FriendRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  // Send a new request
  Future<void> sendFriendRequest(FriendRequestModel request) async {
    try {
      // Document ID is "SenderID_ReceiverID" to prevent duplicate requests
      await _db.collection("FriendRequests").doc("${request.senderId}_${request.receiverId}").set(request.toJson());
    } catch (e) {
      throw "Could not send friend request: $e";
    }
  }

  // Stream of incoming requests for a specific user
  Stream<List<FriendRequestModel>> getIncomingRequests(String uid) {
    return _db.collection("FriendRequests")
        .where("receiverId", isEqualTo: uid)
        .where("status", isEqualTo: "pending")
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => FriendRequestModel.fromSnapshot(doc)).toList());
  }

  // Update status (Accept/Decline)
  Future<void> updateRequestStatus(String requestId, String status) async {
    await _db.collection("FriendRequests").doc(requestId).update({'status': status});
  }
  // Fetch list of users who are officially friends
Stream<List<Usermodel>> getFriendsList(String currentUserId) {
  return _db.collection("FriendRequests")
      .where("status", isEqualTo: "accepted")
      .where(Filter.or(
        Filter("senderId", isEqualTo: currentUserId),
        Filter("receiverId", isEqualTo: currentUserId)
      ))
      .snapshots()
      .asyncMap((snapshot) async {
        List<String> friendIds = [];
        for (var doc in snapshot.docs) {
          final data = doc.data();
          // Get the ID of the OTHER person in the friendship
          if (data['senderId'] == currentUserId) {
            friendIds.add(data['receiverId']);
          } else {
            friendIds.add(data['senderId']);
          }
        }
        
        if (friendIds.isEmpty) return [];

        // Fetch the actual User Profiles for these IDs
        final userSnaps = await _db.collection("users")
            .where(FieldPath.documentId, whereIn: friendIds)
            .get();
            
        return userSnaps.docs.map((doc) => Usermodel.fromSnapshot(doc)).toList();
      });
}
Future<bool> checkIfAlreadyFriends(String currentUserId, String targetUserId) async {
  try {
    final snapshot = await _db.collection("FriendRequests")
        .where("status", isEqualTo: "accepted")
        .where(Filter.or(
          Filter.and(Filter("senderId", isEqualTo: currentUserId), Filter("receiverId", isEqualTo: targetUserId)),
          Filter.and(Filter("senderId", isEqualTo: targetUserId), Filter("receiverId", isEqualTo: currentUserId))
        ))
        .get();

    return snapshot.docs.isNotEmpty;
  } catch (e) {
    return false;
  }
}
}