import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/features/Add_Expenses/model/expense_model.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/features/Add_Expenses/model/expense_model.dart';
import 'package:get/get.dart';

class ExpenseRepository extends GetxController {
  static ExpenseRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  // --- CREATE ---
  Future<void> createExpense(ExpenseModel expense) async {
    await _db.collection("Expenses").add(expense.toJson())
        .whenComplete(() => Get.snackbar("Success", "Expense uploaded"))
        .catchError((error) => Get.snackbar("Error", error.toString()));
  }

  // --- READ (FOR GROUP DETAIL) ---
  Stream<List<ExpenseModel>> getGroupExpenses(String groupId) {
    return _db.collection("Expenses")
        .where("groupId", isEqualTo: groupId)
        .where("status", isEqualTo: "approved") // Only show settled bills in group
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ExpenseModel.fromSnapshot(doc))
            .toList());
  }

  // --- READ (FOR SWIPE ROOM) ---
  // Professionals get all pending bills where the user is invited, 
  // regardless of whether it's a group bill or a personal split.
  Stream<List<ExpenseModel>> getPendingExpensesForUser(String userId) {
    return _db.collection("Expenses")
        .where("status", isEqualTo: "pending")
        .where("splitWith", arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ExpenseModel.fromSnapshot(doc))
            .toList());
  }

  // --- UPDATE (FOR SWIPE ACTION) ---
  Future<void> updateExpenseStatus(String docId, String status) async {
    try {
      await _db.collection("Expenses").doc(docId).update({"status": status});
    } catch (e) {
      Get.snackbar("Error", "Failed to update: $e");
    }
  }
  // --- Inside ExpenseRepository ---

// NEW: Update multi-user confirmations
Future<void> updateConfirmations(String docId, Map<String, dynamic> updatedMap, String globalStatus, {String? reason}) async {
  await _db.collection("Expenses").doc(docId).update({
    "confirmations": updatedMap,
    "status": globalStatus,
    "disputeReason": reason, // Save the reason here
  });
}
// Future<void> updateConfirmations(String docId, Map<String, dynamic> confirmations, String finalStatus) async {
//   try {
//     await _db.collection("Expenses").doc(docId).update({
//       "confirmations": confirmations,
//       "status": finalStatus,
//     });
//   } catch (e) {
//     Get.snackbar("Error", "Failed to update confirmation: $e");
//   }
// }
Future<void> deleteExpense(String docId) async {
    await _db.collection("Expenses").doc(docId).delete();
  }
//   // --- Inside ExpenseRepository ---
// Future<void> updateAndResetExpense({
//   required String docId,
//   required double newAmount,
//   required String newTitle,
//   required List<String> splitWith,
//   required String creatorId,
// }) async {
//   // Reset map: Creator is 'confirmed', everyone else is 'pending'
//   Map<String, String> resetConfirmations = {
//     for (var id in splitWith) id: "pending"
//   };
//   resetConfirmations[creatorId] = "confirmed";

//   await _db.collection("Expenses").doc(docId).update({
//     "amount": newAmount,
//     "title": newTitle,
//     "status": "pending", // Move back from 'disputed' to 'pending'
//     "confirmations": resetConfirmations,
//     "timestamp": DateTime.now(), // Optional: refresh the time
//   });
// }
// }
Future<void> updateAndResetExpense({
  required String docId,
  required double newAmount,
  required String newTitle,
  required List<String> splitWith,
  required Map<String, double> newSplitDetails, // Add this
  required String creatorId,
}) async {
  Map<String, String> resetConfirmations = {
    for (var id in splitWith) id: "pending"
  };
  resetConfirmations[creatorId] = "confirmed";

  await _db.collection("Expenses").doc(docId).update({
    "amount": newAmount,
    "title": newTitle,
    "status": "pending",
    "confirmations": resetConfirmations,
    "splitDetails": newSplitDetails, // Update the map
    "timestamp": DateTime.now(),
  });
} 
// // --- Inside ExpenseRepository ---
// Future<void> updateDisputedExpense({
//   required String docId,
//   required String title,
//   required double amount,
//   required Map<String, double> splitDetails,
//   required List<String> splitWith,
// }) async {
//   try {
//     // 1. Reset all confirmations to "pending"
//     Map<String, String> resetConfirmations = {};
//     for (var uid in splitWith) {
//       resetConfirmations[uid] = "pending";
//     }

//     await _db.collection("Expenses").doc(docId).update({
//       'title': title,
//       'amount': amount,
//       'splitDetails': splitDetails,
//       'confirmations': resetConfirmations,
//       'status': 'pending', // Important: move back to pending
//       'disputeReason': FieldValue.delete(), // Clear the reason
//       'lastUpdated': FieldValue.serverTimestamp(),
//     });
//   } catch (e) {
//     throw "Error updating expense: $e";
//   }
// }
Future<void> updateDisputedExpense({
  required String docId,
  required String title,
  required double amount,
  required Map<String, double> splitDetails,
  required List<String> splitWith,
  required Map<String, String> confirmations, // Add this parameter
}) async {
  await _db.collection("Expenses").doc(docId).update({
    "title": title,
    "amount": amount,
    "splitDetails": splitDetails,
    "confirmations": confirmations, // This resets the checkmarks to pending
    "status": "pending",           // This removes the "Disputed" red badge
    "disputeReason": "",           // Clear the old reason
    "timestamp": FieldValue.serverTimestamp(),
  });
}
}

// class ExpenseRepository extends GetxController {
//   static ExpenseRepository get instance => Get.find();
//   final _db = FirebaseFirestore.instance;

//   // Save new expense to Firestore
//   Future<void> createExpense(ExpenseModel expense) async {
//     await _db.collection("Expenses").add(expense.toJson())
//         .whenComplete(() => Get.snackbar("Success", "Expense uploaded to cloud"))
//         .catchError((error) => Get.snackbar("Error", error.toString()));
//   }

//   // Fetch expenses where the current user is included in splitWith
//   Stream<List<ExpenseModel>> getPendingExpenses(String userId) {
//     return _db.collection("Expenses")
//         .where("splitWith", arrayContains: userId)
//         .snapshots()
//         .map((snapshot) => snapshot.docs.map((doc) => ExpenseModel.fromSnapshot(doc)).toList());
//   }
 
// // Inside ExpenseRepository
// Stream<List<ExpenseModel>> getGroupExpenses(String groupId) {
//   return _db.collection("Expenses")
//       .where("groupId", isEqualTo: groupId) // Ensure this field name matches exactly
//       .orderBy("timestamp", descending: true) // If you use ordering, ensure you have an index
//       .snapshots()
//       .map((snapshot) => snapshot.docs
//           .map((doc) => ExpenseModel.fromSnapshot(doc))
//           .toList());
// }
// }