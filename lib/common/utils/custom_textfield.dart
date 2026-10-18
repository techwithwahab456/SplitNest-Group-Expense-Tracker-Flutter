   // --- Custom Text Field ---
import 'package:expense_tracker_app/common/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:expense_tracker_app/common/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

Widget buildCustomTextField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  bool isPassword = false,
  RxBool? visibilityToggle,
  String? Function(String?)? validator,
}) {
  // REMOVED Obx from here. 
  // We only use .value if it exists to avoid errors.
  return TextFormField(
    controller: controller,
    obscureText: isPassword && !(visibilityToggle?.value ?? false),
    style: const TextStyle(color: Colors.white),
    validator: validator,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.lightGreyColor),
      prefixIcon: Icon(icon, color: AppColors.primaryTeal),
      suffixIcon: isPassword && visibilityToggle != null
        ? IconButton(
            // Accessing .value here is safe because it's inside the parent's Obx
            icon: Icon(
              visibilityToggle.value ? Icons.visibility : Icons.visibility_off, 
              color: Colors.grey
            ),
            onPressed: () => visibilityToggle.toggle(),
          ) 
        : null,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.surfaceColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryTeal),
      ),
      filled: true,
      fillColor: AppColors.surfaceColor,
    ),
  );
}
// --- Custom Primary Button ---
Widget buildPrimaryButton({required String text, required VoidCallback onPressed, bool isLoading = false}) {
  return SizedBox(
    width: double.infinity,
    height: 55,
    child: ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryTeal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: isLoading 
        ? const CircularProgressIndicator(color: Colors.white)
        : Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
    ),
  );
}
   // import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../constant/app_colors.dart';

// class CustomTextFieldWidget extends StatelessWidget {
//   final TextEditingController? controller;
//   final String hintText;
//   final IconData? prefixIcon;
//   final Widget? suffixIcon;
//   final bool obscureText;
//   final TextInputType keyboardType;
//   final String? Function(String?)? validator;

//   const CustomTextFieldWidget({
//     super.key,
//     this.controller,
//     required this.hintText,
//     this.prefixIcon,
//     this.suffixIcon,
//     this.obscureText = false,
//     this.keyboardType = TextInputType.text,
//     this.validator,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       obscureText: obscureText,
//       keyboardType: keyboardType,
//       validator: validator,
//       style: TextStyle(color: AppColors.whiteColor, fontSize: 14.sp),
//       decoration: InputDecoration(
//         hintText: hintText,
//         hintStyle: TextStyle(color: AppColors.lightGreyColor, fontSize: 14.sp),
//         prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: AppColors.primaryTeal, size: 20.sp) : null,
//         suffixIcon: suffixIcon,
//         filled: true,
//         fillColor: AppColors.surfaceColor,
//         contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.r),
//           borderSide: const BorderSide(color: AppColors.btngreyColor),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.r),
//           borderSide: const BorderSide(color: AppColors.primaryTeal, width: 1.5),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.r),
//           borderSide: const BorderSide(color: AppColors.oweColor),
//         ),
//       ),
//     );
//   }
// }