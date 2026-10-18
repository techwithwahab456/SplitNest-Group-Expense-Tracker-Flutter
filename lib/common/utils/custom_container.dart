import 'package:expense_tracker_app/common/constant/app_colors.dart';
import 'package:expense_tracker_app/common/constant/app_shadow_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    this.onTap,
    this.height,
    this.width,
    this.color,
    this.boxShadow,
    this.padding,
    this.boxConstraints,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.child,
    this.margin,
    this.image,
    required this.elevation,
  });

  final EdgeInsetsGeometry? margin;
  final BoxConstraints? boxConstraints;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Widget? child;
  final double? borderRadius;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final double? borderWidth;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;
  final DecorationImage? image;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        constraints: boxConstraints,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          image: image,
          // If elevation > 0, we can apply our cardShadow by default
          boxShadow: boxShadow ?? (elevation > 0 ? AppShadowStyle.cardShadow : null),
          border: Border.all(
            color: borderColor ?? Colors.transparent,
            width: borderWidth ?? 0,
          ),
          color: color ?? AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 15.r),
        ),
        child: child,
      ),
    );
  }
}