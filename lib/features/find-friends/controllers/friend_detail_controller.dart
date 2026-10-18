import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/common/constant/app_colors.dart';
import 'package:expense_tracker_app/datas/repositories/expense_repository.dart';
import 'package:expense_tracker_app/features/Add_Expenses/controllers/split_controller.dart';
import 'package:expense_tracker_app/features/Add_Expenses/model/expense_model.dart';
import 'package:expense_tracker_app/features/auth/controller/usercontroller.dart';
import 'package:expense_tracker_app/features/find-friends/widget/settlement_dialogue.dart';
import 'package:expense_tracker_app/features/profile/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
class FriendDetailController extends GetxController {
  final Usermodel friend;
  final ExpenseRepository exrepo = Get.put(ExpenseRepository());
  
  var expensesList = <ExpenseModel>[].obs;
  var friendBalance = 0.0.obs;
  var isLoading = false.obs;

  // Controllers for the Fix/Edit sheet
  final editTitleController = TextEditingController();
  final editAmountController = TextEditingController();

  FriendDetailController({required this.friend});

  @override
  void onInit() {
    super.onInit();
    _bindExpenses();
  }

  void _bindExpenses() {
    final myId = Usercontroller.instance.user.value.id;
    FirebaseFirestore.instance
        .collection("Expenses")
        .where("groupId", isEqualTo: "") // Personal expenses only
        .where("splitWith", arrayContains: myId)
        .orderBy("timestamp", descending: true)
        .snapshots()
        .listen((snapshot) {
      // Filter for expenses that also include the specific friend
      var filtered = snapshot.docs
          .map((doc) => ExpenseModel.fromSnapshot(doc))
          .where((e) => e.splitWith.contains(friend.id))
          .toList();

      expensesList.value = filtered;
      _calculateNetBalance(myId);
    });
  }

  

  Future<void> processExpenseFix(ExpenseModel original) async {
    final splitController = Get.find<SplitController>();
    try {
      isLoading.value = true;
      await exrepo.updateDisputedExpense(
        docId: original.id!,
        title: editTitleController.text.trim(),
        amount: splitController.totalAmount.value,
        splitDetails: splitController.individualShares,
        splitWith: original.splitWith,
        confirmations: {Usercontroller.instance.user.value.id: "confirmed"},
      );
      Get.back(); // Close sheet
      Get.snackbar("Success", "Expense updated and resent!");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  
  // Method to settle the entire balance at once
 
  // Inside FriendDetailController ...

Future<void> quickSettle() async {
  double currentBalance = friendBalance.value;
  if (currentBalance == 0) return;

  String myId = Usercontroller.instance.user.value.id;
  String myName = Usercontroller.instance.user.value.firstname;

  // If balance is positive, friend owes YOU (You receive money)
  // If balance is negative, YOU owe friend (You pay money)
  String debtorId = currentBalance > 0 ? friend.id : myId;
  String creditorId = currentBalance > 0 ? myId : friend.id;
  String debtorName = currentBalance > 0 ? friend.firstname : myName;

  // showSettleDialog(
  //   Get.context!,
  //   this,
  //   debtorId,
  //   debtorName,
  //   currentBalance.abs(),
  // );
}

// Future<void> settleDebt(String debtorId, String creditorId, double amount) async {
//   try {
//     isLoading.value = true;
    
//     final settlement = ExpenseModel(
//       title: "Settlement Payment",
//       amount: amount,
//       category: "payment", // Triggers the handshake icon
//       createdBy: debtorId,
//       payerName: debtorId == friend.id ? friend.firstname : Usercontroller.instance.user.value.firstname,
//       splitWith: [creditorId],
//       timestamp: DateTime.now(),
//       groupId: "", // Personal
//       groupName: "Personal",
//       status: "approved", // Settlements are auto-approved to clear balance
//       confirmations: {
//         debtorId: "confirmed",
//         creditorId: "confirmed",
//       },
//       splitDetails: {
//         creditorId: amount,
//       },
//     );

//     await exrepo.createExpense(settlement);
//     Get.snackbar("Success", "Balance settled successfully!", 
//         backgroundColor: AppColors.primaryTeal, colorText: Colors.black);
//   } catch (e) {
//     Get.snackbar("Error", "Failed to settle: $e");
//   } finally {
//     isLoading.value = false;
//   }
// }
// ... existing variables ...
  var memberBalances = <String, double>{}.obs; // Add this to match group logic
void _calculateNetBalance(String myId) {
  double net = 0.0;
  
  final approved = expensesList.where((e) => e.status == "approved").toList();

  for (var exp in approved) {
    // Logic: If I paid, I am CREDITED. If Friend paid, I am DEBITED.
    if (exp.createdBy == myId) {
      // I paid the bill. I am owed the friend's share.
      net += (exp.splitDetails[friend.id] ?? 0.0);
    } else {
      // Friend paid the bill. I owe my share to the friend.
      net -= (exp.splitDetails[myId] ?? 0.0);
    }
  }
  
  // result > 0: Friend owes you
  // result < 0: You owe friend
  friendBalance.value = net; 
}

Future<void> settleDebt(double amount) async {
  try {
    isLoading.value = true;
    final myId = Usercontroller.instance.user.value.id;

    // IMPORTANT: To REDUCE a positive balance (friend owes you), 
    // the FRIEND must be the 'createdBy' (the payer) of the settlement.
    final settlement = ExpenseModel(
      title: "Settlement Payment",
      amount: amount,
      category: "payment",
      createdBy: friend.id, // THE DEBTOR IS PAYING
      payerName: friend.firstname,
      splitWith: [myId, friend.id],
      timestamp: DateTime.now(),
      groupId: "", 
      groupName: "Personal",
      status: "approved",
      confirmations: {friend.id: "confirmed", myId: "confirmed"},
      splitDetails: {
        myId: amount,    // The money goes to YOU
        friend.id: 0.0,  // Friend keeps nothing
      },
    );

    await exrepo.createExpense(settlement);
    Get.snackbar("Success", "Balance Cleared", backgroundColor: AppColors.primaryTeal);
  } catch (e) {
    Get.snackbar("Error", "Settle failed: $e");
  } finally {
    isLoading.value = false;
  }
}
Future<void> deleteExpense(String docId) async {
  try {
    isLoading.value = true;
    await FirebaseFirestore.instance.collection("Expenses").doc(docId).delete();
    
    // The balance will auto-update because of your snapshots listener
    Get.snackbar(
      "Deleted", 
      "Expense removed successfully",
      backgroundColor: Colors.redAccent.withOpacity(0.8),
      colorText: Colors.white
    );
  } catch (e) {
    Get.snackbar("Error", "Could not delete: $e");
  } finally {
    isLoading.value = false;
  }
}
 }
// class FriendDetailController extends GetxController {
//   final Usermodel friend;
//   final ExpenseRepository exrepo = Get.find<ExpenseRepository>();
  
//   var expensesList = <ExpenseModel>[].obs;
//   var friendBalance = 0.0.obs;
//   var isLoading = false.obs;

//   // Controllers for the "Fix" bottom sheet
//   final editTitleController = TextEditingController();
//   final editAmountController = TextEditingController();

//   FriendDetailController({required this.friend});

//   @override
//   void onInit() {
//     super.onInit();
//     bindFriendExpenses();
//   }

//   void bindFriendExpenses() {
//     final myId = Usercontroller.instance.user.value.id;
//     // Query expenses where groupId is empty and you are a participant
//     FirebaseFirestore.instance
//         .collection("Expenses")
//         .where("groupId", isEqualTo: "")
//         .where("splitWith", arrayContains: myId)
//         .orderBy("timestamp", descending: true)
//         .snapshots()
//         .listen((snapshot) {
//       // Client-side filter: only keep expenses involving THIS specific friend
//       var filtered = snapshot.docs
//           .map((doc) => ExpenseModel.fromSnapshot(doc))
//           .where((e) => e.splitWith.contains(friend.id))
//           .toList();

//       expensesList.value = filtered;
//       calculateBalance(myId);
//     });
//   }

//   void calculateBalance(String myId) {
//     double total = 0.0;
//     // Only approved expenses affect the formal balance
//     final approved = expensesList.where((e) => e.status == "approved").toList();

//     for (var exp in approved) {
//       if (exp.createdBy == myId) {
//         // You paid: you are owed the friend's share
//         total += (exp.splitDetails[friend.id] ?? 0.0);
//       } else {
//         // Friend paid: you owe your share
//         total -= (exp.splitDetails[myId] ?? 0.0);
//       }
//     }
//     friendBalance.value = total;
//   }

//   Future<void> settleDebt() async {
//     try {
//       isLoading.value = true;
//       final myUser = Usercontroller.instance.user.value;
//       double amount = friendBalance.value.abs();
      
//       // If balance > 0, friend owes you. If < 0, you owe friend.
//       String debtorId = friendBalance.value > 0 ? friend.id : myUser.id;
//       String creditorId = friendBalance.value > 0 ? myUser.id : friend.id;

//       final settlement = ExpenseModel(
//         title: "Settlement Payment",
//         amount: amount,
//         category: "Payment",
//         createdBy: debtorId,
//         payerName: debtorId == myUser.id ? myUser.firstname : friend.firstname,
//         splitWith: [creditorId],
//         timestamp: DateTime.now(),
//         groupId: "", 
//         groupName: "Personal",
//         status: "approved",
//         confirmations: {debtorId: "confirmed", creditorId: "confirmed"},
//         splitDetails: {creditorId: amount},
//       );

//       await exrepo.createExpense(settlement);
//       Get.snackbar("Success", "Settled up!", backgroundColor: AppColors.primaryTeal);
//     } catch (e) {
//       Get.snackbar("Error", "Settle failed: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> processFix(ExpenseModel original) async {
//     final splitController = Get.find<SplitController>();
//     try {
//       isLoading.value = true;
//       await exrepo.updateDisputedExpense(
//         docId: original.id!,
//         title: editTitleController.text.trim(),
//         amount: double.parse(editAmountController.text),
//         splitDetails: splitController.individualShares,
//         splitWith: original.splitWith,
//         confirmations: {Usercontroller.instance.user.value.id: "confirmed"},
//       );
//       Get.back();
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }