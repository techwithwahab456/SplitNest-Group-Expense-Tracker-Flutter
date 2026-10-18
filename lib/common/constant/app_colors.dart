import 'package:flutter/material.dart';

class AppColors {
  // --- Standard Colors ---
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;
  static const Color greyColor = Color(0xff49454F);
  static const Color lightGreyColor = Color(0xff676767);
  static const Color errorColor = Colors.red;

  // --- BudgetBuddy Theme Colors ---
  static const Color bgColor = Color(0xff121212);           // Main dark background
  static const Color surfaceColor = Color(0xff1E1E1E);      // For Cards and Containers
  
  // The "Money" Accents
  static const Color primaryTeal = Color(0xff00D199);       // Modern Green for Branding
  static const Color owedColor = Color(0xff4CAF51);         // Success Green (You are owed)
  static const Color oweColor = Color(0xffFF5252);          // Alert Red (You owe)
  static const Color pendingColor = Color(0xffFFD06B);      // Yellow from your project (Pending Swipe)

  // --- UI Component Colors ---
  static const Color btnPrimaryColor = Color(0xff00D199);   // Save/Settle buttons
  static const Color btngreyColor = Color(0xff35383F);      // Cancel/Secondary buttons
  static const Color textFieldBorderColor = Color(0xffB8B8B8);
  static const Color otpFieldColor = Color(0x8CFFD06B);     // Transparent version of yellow
  
  // --- Social/Group Colors ---
  static const Color crossContainerColor = Color(0xffE6E6E6);
  static const Color lightWhite = Color(0xffD0D0D0);        // For secondary text
}