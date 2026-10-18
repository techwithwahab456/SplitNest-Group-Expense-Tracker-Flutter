import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constant/app_colors.dart';
import '../constant/app_shadow_style.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        boxShadow: AppShadowStyle.topShadow,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: GNav(
          rippleColor: AppColors.btngreyColor,
          hoverColor: AppColors.btngreyColor,
          gap: 4,
          activeColor: AppColors.blackColor, // Text/Icon color when selected
          iconSize: 24,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
          duration: const Duration(milliseconds: 400),
          tabBackgroundColor: AppColors.primaryTeal, // The "Pill" color
          color: AppColors.lightGreyColor, // Unselected icon color
          selectedIndex: currentIndex,
          onTabChange: onTap,
          tabs: const [
            GButton(
              icon: Icons.home_rounded,
              text: 'Home',
            ),
            GButton(
              icon: Icons.swipe_rounded,
              text: 'Swipe',
            ),
            GButton(
              icon: Icons.add_circle_outline_rounded,
              text: 'Add',
            ),
             GButton(
              icon: Icons.group,
              text: 'Groups',
            ),
            GButton(
              icon: Icons.analytics_outlined,
              text: 'Stats',
              
            ),
          ],
        ),
      ),
    );
  }
}