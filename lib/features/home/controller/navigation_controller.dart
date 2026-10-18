import 'package:expense_tracker_app/features/Add_Expenses/controllers/split_controller.dart';
import 'package:get/get.dart';

class BottomNavigationController extends GetxController {
  // Observable variable to store the current index
  var selectedIndex = 0.obs;
 

  // Method to update the index when a tab is clicked
  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}