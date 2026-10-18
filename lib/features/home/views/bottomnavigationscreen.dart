import 'package:expense_tracker_app/common/utils/bottomnavigationbar.dart';
import 'package:expense_tracker_app/features/Add_Expenses/views/add_expense_screen.dart';
import 'package:expense_tracker_app/features/analytics/views/analyticor_status_screen.dart';
import 'package:expense_tracker_app/features/find-friends/views/search_friend_screen.dart';
import 'package:expense_tracker_app/features/home/controller/navigation_controller.dart';
import 'package:expense_tracker_app/features/home/views/homedashboard_screen.dart';
import 'package:expense_tracker_app/features/swipe_room/views/swipe_room_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the controller
    final BottomNavigationController controller = Get.put(BottomNavigationController());

    // Define the list of pages
    final List<Widget> pages = [
       HomeScreen(),      // Tab 0: Home/Dashboard
      const SwipeRoomScreen(), // Tab 1: Swipe Room
       AddExpenseScreen(),
       SocialHubScreen(),
        // Tab 2: Placeholder for Add
      const StatsScreen(),   // Tab 3: Placeholder for Stats
    ];

    return Scaffold(
      // Obx listens to changes in selectedIndex
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: pages,
        ),
      ),
      
      // Our Custom Navbar
      bottomNavigationBar: Obx(
        () => CustomBottomNavBar(
          currentIndex: controller.selectedIndex.value,
          onTap: (index) => controller.changeIndex(index),
        ),
      ),
    );
  }
}