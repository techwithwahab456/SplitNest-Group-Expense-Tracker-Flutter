import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/datas/repositories/authrepository.dart';
import 'package:expense_tracker_app/features/profile/model/user_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save user data to Firestore
  Future<void> saveUser(Usermodel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toJson());
    } on FirebaseException catch (e) {
      throw 'Firestore error: ${e.message}';
    } on PlatformException catch (e) {
      throw 'Platform error: ${e.message}';
    }
  }

  // Fetch data for any user by their ID (useful for showing who paid a bill)
  Future<Usermodel> fetchUserData(String userId) async {
    try {
      final snapshot = await _firestore.collection('users').doc(userId).get();
      return snapshot.exists ? Usermodel.fromSnapshot(snapshot) : Usermodel.empty();
    } on FirebaseException catch (e) {
      throw 'Firestore error: ${e.message}';
    }
  }

  // Update current user's profile info
  Future<void> updateUserData(Usermodel updatedUser) async {
    try {
      await _firestore.collection('users').doc(updatedUser.id).update(updatedUser.toJson());
    } on FirebaseException catch (e) {
      throw 'Firestore error: ${e.message}';
    }
  }

  // Update a specific field (like changing a username or profile URL)
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      final userId = AuthRepository.instance.currentUser?.uid;
      if (userId == null) throw 'User not authenticated';
      await _firestore.collection('users').doc(userId).update(json);
    } on FirebaseException catch (e) {
      throw 'Firestore error: ${e.message}';
    }
  }
  // Fetch a single user by email for the search feature
Future<Usermodel?> getUserByEmail(String email) async {
  try {
    final snapshot = await _firestore.collection("users").where("email", isEqualTo: email).get();
    if (snapshot.docs.isNotEmpty) {
      return Usermodel.fromSnapshot(snapshot.docs.first);
    }
    return null;
  } catch (e) {
    throw "Error fetching user: $e";
  }
}
}