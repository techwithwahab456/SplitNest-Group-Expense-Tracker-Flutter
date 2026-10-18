import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DashboardRepository extends GetxController {
  static DashboardRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  // Stream all approved expenses to calculate balances and show history
  Stream<QuerySnapshot<Map<String, dynamic>>> getApprovedExpenses() {
    return _db
        .collection("Expenses")
        .where("status", isEqualTo: "approved")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }
}