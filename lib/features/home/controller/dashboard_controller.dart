import 'package:expense_tracker_app/datas/repositories/dashboard_repository.dart';
import 'package:expense_tracker_app/features/auth/controller/usercontroller.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final _repo = Get.put(DashboardRepository());
  final userController = Usercontroller.instance;

  var totalOwedToYou = 0.0.obs;
  var totalYouOwe = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    calculateTotals();
  }

  void calculateTotals() {
    // Get real ID and Name from your Auth/User Controller
    final String currentUserId = userController.user.value.id;

    _repo.getApprovedExpenses().listen((snapshot) {
      double owedToMe = 0.0;
      double iOwe = 0.0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        double amount = (data['amount'] ?? 0.0).toDouble();
        List splitWith = data['splitWith'] ?? [];
        
        if (splitWith.isEmpty) continue;

        // Logic: Total People = length of splitWith (which includes creator in our updated flow)
        int totalPeople = splitWith.length;
        double perPersonShare = amount / totalPeople;

        // CASE 1: You paid the bill
        if (data['createdBy'] == currentUserId) {
          // Others owe you the total amount minus your own share
          owedToMe += (amount - perPersonShare);
        } 
        // CASE 2: Someone else paid, but you are in the split list
        else if (splitWith.contains(currentUserId)) {
          iOwe += perPersonShare;
        }
      }

      totalOwedToYou.value = owedToMe;
      totalYouOwe.value = iOwe;
    });
  }
}

  // void calculateTotals() {
  //   _repo.getApprovedExpenses().listen((snapshot) {
  //     double owedToMe = 0.0;
  //     double iOwe = 0.0;

  //     for (var doc in snapshot.docs) {
  //       final data = doc.data();
  //       double amount = (data['amount'] ?? 0.0).toDouble();
  //       List splitWith = data['splitWith'] ?? [];
        
  //       // Total people sharing = splitWith list + the creator
  //       int totalPeople = splitWith.length + 1;
  //       double perPersonShare = amount / totalPeople;

  //       if (data['createdBy'] == currentUserId) {
  //         // You paid: Others owe you (Total - Your own share)
  //         owedToMe += (amount - perPersonShare);
  //       } else if (splitWith.contains(currentUserName)) {
  //         // Someone else paid: You owe them your individual share
  //         iOwe += perPersonShare;
  //       }
  //     }
  //     totalOwedToYou.value = owedToMe;
  //     totalYouOwe.value = iOwe;
  //   });
  // }
