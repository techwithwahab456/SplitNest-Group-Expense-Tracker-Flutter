// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';

// class SwipeRepository extends GetxController {
//   static SwipeRepository get instance => Get.find();
//   final FirebaseFirestore _db = FirebaseFirestore.instance;

//   // Stream of pending expenses
//  // Inside swipe_controller.dart

// Stream<QuerySnapshot<Map<String, dynamic>>> getPendingExpenses() {
//   // Replace "Ahmed" with your actual current user's name or ID
//   // In the future, this will be AuthRepo.instance.user.uid
//   String currentBuddyName = "Ahmed"; 

//   return _db
//       .collection("Expenses")
//      .where("status", isEqualTo: "pending") 
//       // 🔥 This is the fix: Only show bills where this user is invited to split
//       .where("splitWith", arrayContains: currentBuddyName)
//       .orderBy("timestamp", descending: true)
//       .snapshots();
// }

//   // Update status in Firestore
//   Future<void> updateExpenseStatus(String docId, String status) async {
//     try {
//       await _db.collection("Expenses").doc(docId).update({"status": status});
//     } catch (e) {
//       Get.snackbar("Error", "Failed to update status: $e");
//     }
//   }
// }