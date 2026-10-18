import 'package:expense_tracker_app/common/constant/app_colors.dart';
import 'package:expense_tracker_app/features/Add_Expenses/controllers/split_controller.dart';
import 'package:expense_tracker_app/features/Add_Expenses/model/buddy_model.dart';
import 'package:expense_tracker_app/features/Add_Expenses/model/expense_model.dart';
import 'package:expense_tracker_app/features/Add_Expenses/views/add_expense_screen.dart';
import 'package:expense_tracker_app/features/Add_Expenses/widgets/build_splitdetails.dart';
import 'package:expense_tracker_app/features/auth/controller/usercontroller.dart';
import 'package:expense_tracker_app/features/find-friends/controllers/friend_detail_controller.dart';
import 'package:expense_tracker_app/features/find-friends/widget/settlement_dialogue.dart';
import 'package:expense_tracker_app/features/profile/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
class FriendDetailScreen extends StatelessWidget {
  final Usermodel friend;
  const FriendDetailScreen({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FriendDetailController(friend: friend));
    final myId = Usercontroller.instance.user.value.id;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(title: Text(friend.firstname), backgroundColor: Colors.transparent),
      body: Column(
        children: [
          _buildBalanceHeader(controller),
          const Divider(color: Colors.white10),
          Expanded(child: _buildTransactionList(controller, myId)),
          
        ],
      ),
     floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryTeal,
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () {
          // Pass 'Personal' context to the AddExpenseScreen
          Get.to(() => AddExpenseScreen(
            groupId: "", // Empty for personal
            groupName: "Personal",
            groupMembers: [
              Usercontroller.instance.user.value, // Yourself
              friend, // The specific friend from this page
            ],
          ));
        },
      ),
    );
  }

  Widget _buildTransactionList(FriendDetailController controller, String myId) {
    return Obx(() => ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: controller.expensesList.length,
      itemBuilder: (context, index) {
        final expense = controller.expensesList[index];
        final bool isMyExpense = expense.createdBy == myId;

        return Card(
          color: AppColors.surfaceColor,
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: Icon(_getIcon(expense.category), color: AppColors.primaryTeal),
            title: Text(expense.title, style: const TextStyle(color: Colors.white)),
            subtitle: Text(isMyExpense ? "You paid" : "${friend.firstname} paid", style: const TextStyle(fontSize: 11, color: Colors.grey)),
           trailing: _buildTrailing(expense, myId, controller),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. DISPUTE REASON
                    if (expense.status == "disputed" && expense.disputeReason != null)
                      _buildDisputeBox(expense.disputeReason!),

                    // 2. APPROVAL STATUS (Simplified for 2 people)
                    const Text("Approval Status:", style: TextStyle(color: Colors.grey, fontSize: 11)),
                    const SizedBox(height: 8),
                    _buildMiniStatusRow(expense, controller.friend),

                    // 3. FIX BUTTON
                    if (expense.status == "disputed" && isMyExpense)
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: const Size(double.infinity, 35)),
                          onPressed: () => showEditExpenseSheet(context, expense, controller),
                          icon: const Icon(Icons.edit, size: 16, color: Colors.black),
                          label: const Text("Fix & Resend", style: TextStyle(color: Colors.black)),
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    ));
  }

  Widget _buildDisputeBox(String reason) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
      ),
      child: Text("Dispute: $reason", style: const TextStyle(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic)),
    );
  }

  Widget _buildMiniStatusRow(ExpenseModel expense, Usermodel friend) {
    final status = expense.confirmations?[friend.id] ?? "pending";
    return Row(
      children: [
        CircleAvatar(radius: 10, backgroundImage: NetworkImage(friend.profilepicture)),
        const SizedBox(width: 8),
        Text(friend.firstname, style: const TextStyle(color: Colors.white, fontSize: 12)),
        const Spacer(),
        Icon(
          status == "confirmed" ? Icons.check_circle : (status == "rejected" ? Icons.cancel : Icons.access_time_filled),
          size: 16,
          color: status == "confirmed" ? Colors.green : (status == "rejected" ? Colors.red : Colors.orange),
        )
      ],
    );
  }
  // --- FriendDetailScreen ---
  // --- Inside FriendDetailScreen ---
  Widget _buildBalanceHeader(FriendDetailController controller) {
  return Obx(() {
    final double bal = controller.friendBalance.value;

    return Column(
      children: [
        Text(
          // Logic: Positive = they owe you. Negative = you owe them.
          bal > 0 ? "Friend owes you" : (bal < 0 ? "You owe friend" : "Settled Up"),
          style: const TextStyle(color: Colors.grey),
        ),
        Text(
          "PKR ${bal.abs().toStringAsFixed(0)}",
          style: TextStyle(
            // Green if they owe you, Red if you owe them
            color: bal > 0 ? AppColors.primaryTeal : (bal < 0 ? Colors.redAccent : Colors.grey),
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        if (bal > 0) // Only show 'Received' button if THEY owe YOU
          ElevatedButton(
            onPressed: () => showSettleDialog(controller, bal.abs()),
            child: const Text("I Received Cash"),
          ),
      ],
    );
  });
}
IconData _getIcon(String category) {
  switch (category.toLowerCase()) {
    case 'food': return Icons.restaurant;
    case 'shopping': return Icons.shopping_bag;
    case 'travel': return Icons.directions_car;
    case 'rent': return Icons.home;
    case 'fun': return Icons.movie;
    case 'payment': return Icons.handshake; // Special icon for settlements
    default: return Icons.receipt_long;
  }
}
Widget _buildTrailing(ExpenseModel expense, String myId, FriendDetailController controller) {
  final bool isMyExpense = expense.createdBy == myId;

  return SizedBox(
    width: 130, // Increased width to fit the delete icon
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "PKR ${expense.amount.toStringAsFixed(0)}",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _getStatusColor(expense.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                expense.status.toUpperCase(),
                style: TextStyle(color: _getStatusColor(expense.status), fontSize: 8, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        
        // DELETE ICON: Only visible to the person who created the expense
        if (isMyExpense)
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
            onPressed: () => _confirmDelete(expense, controller),
          ),
      ],
    ),
  );
}
void _confirmDelete(ExpenseModel expense, FriendDetailController controller) {
  Get.defaultDialog(
    backgroundColor: AppColors.surfaceColor,
    title: "Delete Expense",
    titleStyle: const TextStyle(color: Colors.white),
    middleText: "Are you sure you want to delete '${expense.title}'?",
    middleTextStyle: const TextStyle(color: Colors.grey),
    textConfirm: "Delete",
    confirmTextColor: Colors.white,
    buttonColor: Colors.redAccent,
    onConfirm: () {
      controller.deleteExpense(expense.id!);
      Get.back(); // Close dialog
    },
    textCancel: "Cancel",
    cancelTextColor: Colors.white,
  );
}

Color _getStatusColor(String status) {
  if (status == "approved") return AppColors.primaryTeal;
  if (status == "disputed") return Colors.redAccent;
  return Colors.orange;
}
void showEditExpenseSheet(BuildContext context, ExpenseModel expense, FriendDetailController controller) {
  final splitController = Get.put(SplitController());
  
  // 1. Pre-fill basic details
  controller.editTitleController.text = expense.title;
  controller.editAmountController.text = expense.amount.toString();
  
  // 2. Setup SplitController for 1-on-1
  splitController.totalAmount.value = expense.amount;
  splitController.individualShares.assignAll(expense.splitDetails);

  // 3. Populate Buddy List (Just you and the friend)
  var involvedBuddies = [
    Buddy(
      id: controller.friend.id, 
      name: controller.friend.firstname, 
      image: controller.friend.profilepicture,
      isSelected: true, 
    )
  ];
  splitController.availableBuddies.assignAll(involvedBuddies);

  // 4. Check if it was an equal split
  final details = expense.splitDetails;
  if (details.isNotEmpty) {
    double firstShare = details.values.first;
    splitController.isSplitEqually.value = details.values.every((v) => (v - firstShare).abs() < 0.1);
  }

  Get.bottomSheet(
    isScrollControlled: true,
    backgroundColor: AppColors.bgColor,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Fix Disputed Expense", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            TextField(
              controller: controller.editTitleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Title", labelStyle: TextStyle(color: Colors.grey)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller.editAmountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              onChanged: (val) {
                double amt = double.tryParse(val) ?? 0.0;
                splitController.totalAmount.value = amt;
                if (splitController.isSplitEqually.value) splitController.calculateEqualSplit();
              },
              decoration: const InputDecoration(labelText: "Total Amount", prefixText: "PKR "),
            ),
            
            const SizedBox(height: 20),
            // Re-using the split details widget from your Add Expense flow
            buildSplitDetails(splitController),
            
            const SizedBox(height: 30),
            Obx(() => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTeal,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: controller.isLoading.value 
                  ? null 
                  : () => controller.processExpenseFix(expense),
              child: controller.isLoading.value 
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text("Resend to Friend", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            )),
          ],
        ),
      ),
    ),
  );
}
}