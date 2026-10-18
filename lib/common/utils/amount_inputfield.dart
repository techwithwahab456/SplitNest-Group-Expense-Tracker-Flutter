import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constant/app_colors.dart';
import '../utils/text_widget.dart';

class AmountInputField extends StatelessWidget {
  final TextEditingController controller;
  final String currency;

  const AmountInputField({super.key, required this.controller, this.currency = "PKR"});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.primaryTeal,
          fontSize: 40.sp,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          prefixText: "$currency ",
          prefixStyle: TextStyle(color: AppColors.lightGreyColor, fontSize: 20.sp),
          hintText: "0",
          hintStyle: TextStyle(color: AppColors.btngreyColor),
          border: InputBorder.none,
        ),
      ),
    );
  }
}