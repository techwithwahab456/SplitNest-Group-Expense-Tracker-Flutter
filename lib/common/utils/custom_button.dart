//_______________________________CustomButton___________________________________

import 'package:expense_tracker_app/common/constant/app_colors.dart';
import 'package:expense_tracker_app/common/constant_classes/Wapp_sizes.dart';
import 'package:expense_tracker_app/common/utils/custom_container.dart';
import 'package:expense_tracker_app/common/utils/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constant/app_colors.dart';
import '../constant/app_shadow_style.dart';
import '../utils/text_widget.dart';
import '../utils/custom_container.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.height,
    this.width,
    this.fontSize,
    this.textColor,
    required this.onTap,
    this.fontWeight,
    this.borderRadius,
    this.containerColor,
    required this.text,
    this.borderColor,
    this.borderWidth,
    this.isLoading = false,
    this.loadingText,
    this.loadingColor,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.buttonType = ButtonType.primary,
    this.elevation,
    this.padding,
    this.isEnabled = true,
    this.textType,
  });

  final double? height;
  final double? width;
  final double? fontSize;
  final Color? textColor;
  final Color? borderColor;
  final Color? containerColor;
  final Color? loadingColor;
  final VoidCallback onTap;
  final FontWeight? fontWeight;
  final double? borderRadius;
  final double? borderWidth;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final String text;
  final String? loadingText;
  final bool isLoading;
  final Widget? icon;
  final IconPosition iconPosition;
  final ButtonType buttonType;
  final bool isEnabled;
  final TextType? textType;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: CustomContainer(
        onTap: isEnabled && !isLoading ? onTap : null,
        height: height ?? 52.h,
        width: width ?? double.infinity,
        borderRadius: borderRadius ?? 12.r,
        borderColor: borderColor ?? buttonStyle.borderColor,
        borderWidth: borderWidth ?? buttonStyle.borderWidth,
        color: containerColor ?? buttonStyle.backgroundColor,
        boxShadow: buttonType == ButtonType.primary ? AppShadowStyle.primaryBtnShadow : null,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
        elevation: elevation ?? 0, 
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedOpacity(
              opacity: isLoading ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: _buildButtonContent(),
            ),
            if (isLoading) _buildLoadingIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null && iconPosition == IconPosition.left) ...[
          icon!,
          SizedBox(width: 8.w),
        ],
        Flexible(
          child: TextWidget(
            text: text,
            fontSize: fontSize,
            color: textColor ?? _getTextColor(),
            fontWeight: fontWeight ?? FontWeight.bold,
            textType: textType ?? TextType.buttonText,
            textAlign: TextAlign.center,
          ),
        ),
        if (icon != null && iconPosition == IconPosition.right) ...[
          SizedBox(width: 8.w),
          icon!,
        ],
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 18.w,
          height: 18.w,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(loadingColor ?? _getTextColor()),
          ),
        ),
        if (loadingText != null) ...[
          SizedBox(width: 10.w),
          TextWidget(text: loadingText!, color: _getTextColor(), textType: TextType.buttonText),
        ],
      ],
    );
  }

  Color _getTextColor() {
    switch (buttonType) {
      case ButtonType.primary: return AppColors.blackColor; // Black text on Teal looks premium
      case ButtonType.danger: return AppColors.whiteColor;
      case ButtonType.outline: return AppColors.primaryTeal;
      default: return AppColors.whiteColor;
    }
  }

  ButtonStyleConfig _getButtonStyle() {
    switch (buttonType) {
      case ButtonType.primary:
        return ButtonStyleConfig(backgroundColor: AppColors.primaryTeal, borderColor: Colors.transparent, borderWidth: 0);
      case ButtonType.secondary:
        return ButtonStyleConfig(backgroundColor: AppColors.btngreyColor, borderColor: Colors.transparent, borderWidth: 0);
      case ButtonType.outline:
        return ButtonStyleConfig(backgroundColor: Colors.transparent, borderColor: AppColors.primaryTeal, borderWidth: 1.5.w);
      case ButtonType.danger:
        return ButtonStyleConfig(backgroundColor: AppColors.oweColor, borderColor: Colors.transparent, borderWidth: 0);
      default:
        return ButtonStyleConfig(backgroundColor: AppColors.primaryTeal, borderColor: Colors.transparent, borderWidth: 0);
    }
  }
}

enum ButtonType { primary, secondary, outline, text, danger }
enum IconPosition { left, right }

class ButtonStyleConfig {
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  ButtonStyleConfig({required this.backgroundColor, required this.borderColor, required this.borderWidth});
}
// CustomButton(
//   text: 'Book Appointment',
//   onTap: () {},
// )
// // Primary Button (Default)
// CustomButton(
//   text: 'Confirm Booking',
//   onTap: () {},
//   buttonType: ButtonType.primary,
// )

// // Secondary Button
// CustomButton(
//   text: 'Cancel',
//   onTap: () {},
//   buttonType: ButtonType.secondary,
// )

// // Outline Button
// CustomButton(
//   text: 'Edit Booking',
//   onTap: () {},
//   buttonType: ButtonType.outline,
// )

// // Text Button
// CustomButton(
//   text: 'Skip',
//   onTap: () {},
//   buttonType: ButtonType.text,
// )

// // Danger Button
// CustomButton(
//   text: 'Delete Booking',
//   onTap: () {},
//   buttonType: ButtonType.danger,
// )
// CustomButton(
//   text: 'Book Now',
//   onTap: () {},
//   icon: Icon(Icons.calendar_today, size: AppSizes.iconSm),
//   iconPosition: IconPosition.left,
// )
// CustomButton(
//   text: 'Processing',
//   onTap: () {},
//   isLoading: true,
//   loadingText: 'Booking...',
// )
// // Primary button with extension
// 'Book Appointment'.primaryButton(
//   onTap: () {},
//   icon: Icon(Icons.calendar_today),
// )

// // Secondary button
// 'Cancel'.secondaryButton(onTap: () {})

// // Outline button  
// 'Reschedule'.outlineButton(onTap: () {})
// CustomButton(
//   text: 'Book Appointment',
//   onTap: () {},
//   isEnabled: false, // Button will be disabled
// )