import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/features/friends_group/model/group_model.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class GroupRepository extends GetxController {
  static GroupRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  Future<void> createNewGroup(GroupModel group) async {
    try {
      await _db.collection("Groups").add(group.toJson());
    } catch (e) {
      throw "Error creating group: $e";
    }
  }

  // Fetch only groups where user has "accepted"
  Stream<List<GroupModel>> getActiveGroups(String uid) {
    return _db.collection("Groups")
        .where("members", arrayContains: uid)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => GroupModel.fromSnapshot(doc))
            .where((g) {
              // Logic: Show if status is accepted OR if user is creator
              return g.memberStatus[uid] == 'accepted' || g.creatorId == uid;
            })
            .toList());
  }

  // Fetch pending group invites
  Stream<List<GroupModel>> getPendingGroupInvites(String uid) {
    return _db.collection("Groups")
        .where("members", arrayContains: uid)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => GroupModel.fromSnapshot(doc))
            .where((g) {
              // Logic: Show only if specifically pending and NOT the creator
              return g.memberStatus[uid] == 'pending' && g.creatorId != uid;
            })
            .toList());
  }

  Future<void> acceptGroupInvite(String groupId, String userId) async {
    await _db.collection("Groups").doc(groupId).update({
      'memberStatus.$userId': 'accepted'
    });
  }


  // Future<void> createNewGroup(GroupModel group) async {
  //   try {
  //     await _db.collection("Groups").add(group.toJson());
  //   } catch (e) {
  //     throw "Error creating group: $e";
  //   }
  // }

  // // Stream groups where the current user is a member
  // Stream<List<GroupModel>> getUserGroups(String uid) {
  //   return _db.collection("Groups")
  //       .where("members", arrayContains: uid)
  //       .snapshots()
  //       .map((snap) => snap.docs.map((doc) => GroupModel.fromSnapshot(doc)).toList());
  // }

  // Update Group Name
  Future<void> updateGroupName(String groupId, String newName) async {
    await _db.collection("Groups").doc(groupId).update({'groupName': newName});
  }

  // Delete Group
  Future<void> deleteGroup(String groupId) async {
    await _db.collection("Groups").doc(groupId).delete();
  }
  // Add to GroupRepository class
Future<void> removeMember(String groupId, String userId) async {
  await _db.collection("Groups").doc(groupId).update({
    'members': FieldValue.arrayRemove([userId]),
    'memberStatus.$userId': FieldValue.delete(),
  });
}

Future<void> addMember(String groupId, String userId) async {
  await _db.collection("Groups").doc(groupId).update({
    'members': FieldValue.arrayUnion([userId]),
    'memberStatus.$userId': 'pending',
  });
}


  // // Accept Group Invite
  // Future<void> acceptGroupInvite(String groupId, String userId) async {
  //   await _db.collection("Groups").doc(groupId).update({
  //     'memberStatus.$userId': 'accepted'
  //   });
  // }

  // // Fetch only groups where user has "accepted"
  // Stream<List<GroupModel>> getActiveGroups(String uid) {
  //   return _db.collection("Groups")
  //       .where("members", arrayContains: uid)
  //       .snapshots()
  //       .map((snap) => snap.docs
  //           .map((doc) => GroupModel.fromSnapshot(doc))
  //           .where((g) => g.memberStatus[uid] == 'accepted')
  //           .toList());
  // }

  // // Fetch pending group invites
  // Stream<List<GroupModel>> getPendingGroupInvites(String uid) {
  //   return _db.collection("Groups")
  //       .where("members", arrayContains: uid)
  //       .snapshots()
  //       .map((snap) => snap.docs
  //           .map((doc) => GroupModel.fromSnapshot(doc))
  //           .where((g) => g.memberStatus[uid] == 'pending')
  //           .toList());
  // }
}