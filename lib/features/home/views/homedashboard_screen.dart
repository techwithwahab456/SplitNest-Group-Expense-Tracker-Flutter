import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/common/constant_classes/Wapp_sizes.dart';
import 'package:expense_tracker_app/common/utils/balance_card.dart';
import 'package:expense_tracker_app/common/utils/group_tile.dart';
import 'package:expense_tracker_app/datas/repositories/dashboard_repository.dart';
import 'package:expense_tracker_app/features/Add_Expenses/views/add_expense_screen.dart';
import 'package:expense_tracker_app/features/home/controller/dashboard_controller.dart';
import 'package:expense_tracker_app/features/home/widgets/buildheader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:expense_tracker_app/common/constant/app_colors.dart';

import 'package:expense_tracker_app/common/utils/text_widget.dart';


class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});
  // Inside DashboardScreen
final controller = Get.put(DashboardController());

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgColor,
    body: SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            buildHeader(),
            SizedBox(height: 25.h),

            // --- Balance Section ---
            Row(
              children: [
                Expanded(
                  child: Obx(() => _buildBalanceCard(
                        "Owed to You",
                        "PKR ${controller.totalOwedToYou.value.toStringAsFixed(0)}",
                        AppColors.primaryTeal,
                      )),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Obx(() => _buildBalanceCard(
                        "You Owe",
                        "PKR ${controller.totalYouOwe.value.toStringAsFixed(0)}",
                        AppColors.oweColor,
                      )),
                ),
              ],
            ),

            SizedBox(height: 30.h),
            Align(
              alignment: Alignment.centerLeft,
              child: TextWidget(text: "Recent Activity", textType: TextType.headlineSmall),
            ),
            SizedBox(height: 10.h),

            // --- Recent Activity List ---
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: Get.find<DashboardRepository>().getApprovedExpenses(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  
                  final docs = snapshot.data!.docs;
                  
                  return ListView.builder(
                    itemCount: docs.length,
                  itemBuilder: (context, index) {
                    // Inside ListView.builder -> itemBuilder
final data = docs[index].data();
final String currentUserId = controller.userController.user.value.id;

double totalAmount = (data['amount'] ?? 0.0).toDouble();
List splitWith = data['splitWith'] ?? [];
int totalPeople = splitWith.length;
double myShare = totalAmount / totalPeople;

bool iPaid = data['createdBy'] == currentUserId;

return ListTile(
  // ... existing leading and title code ...
  subtitle: Row(
    children: [
      TextWidget(
        // Use payerName from the database document
        text: iPaid ? "You paid" : "Paid by ${data['payerName'] ?? 'Someone'}", 
        textType: TextType.bodySmall, 
        color: AppColors.lightGreyColor
      ),
      SizedBox(width: 8.w),
      // Only show SETTLED badge if the category is 'Payment'
      if(data['category'] == 'Payment')
        buildSettledBadge(),
    ],
  ),
  trailing: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      TextWidget(
        text: "Rs. ${totalAmount.toStringAsFixed(0)}", 
        textType: TextType.bodyMedium,
      ),
      TextWidget(
        // If I paid, show what I get back. If someone else paid, show what I owe.
        text: iPaid 
          ? "Get back: Rs. ${(totalAmount - myShare).toStringAsFixed(0)}" 
          : "Your share: Rs. ${myShare.toStringAsFixed(0)}",
        textType: TextType.bodySmall,
        color: iPaid ? AppColors.primaryTeal : AppColors.oweColor,
      ),
    ],
  ),
);
}
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
     // Quick Add FAB
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryTeal,
        onPressed: () { 
          Get.to(()=>AddExpenseScreen());
        },
        child: const Icon(Icons.add, color: AppColors.blackColor),
      ),
  );
}
Widget buildSettledBadge() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
    decoration: BoxDecoration(
      color: AppColors.primaryTeal.withOpacity(0.1),
      borderRadius: BorderRadius.circular(5.r),
      border: Border.all(color: AppColors.primaryTeal.withOpacity(0.3), width: 0.5),
    ),
    child: TextWidget(
      text: "SETTLED", 
      textType: TextType.bodySmall, 
      color: AppColors.primaryTeal,
    ),
  );
}
// Helper Widget for Balance Card
Widget _buildBalanceCard(String title, String amount, Color color) {
  return Container(
    padding: EdgeInsets.all(15.w),
    decoration: BoxDecoration(
      color: AppColors.surfaceColor,
      borderRadius: BorderRadius.circular(15.r),
      border: Border(left: BorderSide(color: color, width: 4)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(text: title, textType: TextType.bodySmall, color: AppColors.lightGreyColor),
        SizedBox(height: 5.h),
        TextWidget(text: amount, textType: TextType.headlineSmall, color: color),
      ],
    ),
  );
}
// 2. Category Icon Picker
IconData _getIcon(String? category) {
  switch (category) {
    case 'Food':
      return Icons.restaurant_rounded;
    case 'Rent':
      return Icons.home_work_rounded;
    case 'Shopping':
      return Icons.shopping_bag_rounded;
    case 'Travel':
      return Icons.directions_car_rounded;
    case 'Bills':
      return Icons.receipt_long_rounded;
    default:
      return Icons.miscellaneous_services_rounded;
  }
}
      
      // Quick Add FAB
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: AppColors.primaryTeal,
      //   onPressed: () { 
      //     Get.to(()=>AddExpenseScreen());
      //   },
      //   child: const Icon(Icons.add, color: AppColors.blackColor),
      // ),
    
  
}