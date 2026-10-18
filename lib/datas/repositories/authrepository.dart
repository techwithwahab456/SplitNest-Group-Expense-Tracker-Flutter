import 'package:expense_tracker_app/common/constant_classes/firebaseauth_exception.dart';
import 'package:expense_tracker_app/common/constant_classes/networkmanage_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthRepository extends GetxController {
  static AuthRepository get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final NetworkManager _networkManager = NetworkManager();

  // Observable to track user state globally
  Rx<User?> firebaseUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    // Bind the firebaseUser to the auth state changes
    firebaseUser.bindStream(_auth.userChanges());
  }

  @override
  void onReady() {
    super.onReady();
  //  screenRedirect();
  }

  // Handle local storage and initial routing
  // void screenRedirect() async {
  //   final user = _auth.currentUser;
  //   if (user != null) {
  //     await WLocalStorage.init(user.uid);
  //   }
  // }

  // --- Authentication Functions ---

  Future<UserCredential> signUpWithEmailPassword({required String email, required String password}) async {
    if (!await _networkManager.isConnected()) throw Exception('No internet connection');
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthExceptionHandler.handleException(e);
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  Future<UserCredential> loginWithEmailPassword({required String email, required String password}) async {
    if (!await _networkManager.isConnected()) throw Exception('No internet connection');
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthExceptionHandler.handleException(e);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    if (!await _networkManager.isConnected()) throw Exception('No internet connection');
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Google sign-in cancelled');

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthExceptionHandler.handleException(e);
    } catch (e) {
      throw Exception('Google sign-in failed: $e');
    }
  }

  // --- Password & Verification ---

  Future<void> sendPasswordResetEmail(String email) async {
    if (!await _networkManager.isConnected()) throw Exception('No internet connection');
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthExceptionHandler.handleException(e);
    }
  }

  Future<void> resendVerificationEmail() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No authenticated user found');
    try {
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthExceptionHandler.handleException(e);
    }
  }

  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      throw 'Logout error: $e';
    }
  }

  User? get currentUser => _auth.currentUser;
}