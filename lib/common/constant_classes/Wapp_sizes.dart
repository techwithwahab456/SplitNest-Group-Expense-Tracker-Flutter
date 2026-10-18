import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSizes { 
  // --- Screen Breakpoints ---
  static const double mobileBreakpoint = 360.0;
  static const double tabletBreakpoint = 768.0;

  // --- Padding & Margin (Width Based) ---
  static double get xs => 4.0.w;
  static double get sm => 8.0.w;
  static double get md => 16.0.w;
  static double get lg => 24.0.w;
  static double get xl => 32.0.w;
  
  // --- Height Based Spacing ---
  static double get hXs => 4.0.h;
  static double get hSm => 8.0.h;
  static double get hMd => 16.0.h;
  static double get hLg => 24.0.h;

  // --- Typography (Scaling Pixels) ---
  static double get fontSizeSm => 12.0.sp;
  static double get fontSizeMd => 14.0.sp;
  static double get fontSizeLg => 16.0.sp;
  static double get fontSizeXl => 18.0.sp;
  static double get fontSizeDisplay => 32.0.sp; // For Big Amount display

  // --- Button & Input Heights ---
  static double get buttonHeight => 52.0.h;
  static double get inputFieldHeight => 56.0.h;
  static double get buttonRadius => 12.0.r; // Use .r for radius
  static double get cardRadius => 16.0.r;

  // --- Icon Sizes ---
  static double get iconSm => 18.0.w;
  static double get iconMd => 24.0.w;
  static double get iconLg => 32.0.w;

  // --- FinTech Specific Sizes ---
  static double get swipeCardHeight => 450.0.h;
  static double get swipeCardWidth => 320.0.w;
  static double get avatarSm => 32.0.r;
  static double get avatarMd => 48.0.r;
  static double get avatarLg => 64.0.r;
  
  // --- Layout Spacing ---
  static double get defaultSpace => 24.0.w;
  static double get spaceBtwItems => 16.0.w;
  static double get spaceBtwSections => 32.0.w;

  // --- Chart Sizes ---
  static double get pieChartHeight => 200.0.h;
}