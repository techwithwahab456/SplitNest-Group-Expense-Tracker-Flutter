import 'package:expense_tracker_app/common/constant/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final TextType? textType;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;

  const TextWidget({
    super.key,
    required this.text,
    this.textType,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle = _getBaseStyle();

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.poppins(
        color: color ?? baseStyle.color,
        fontSize: fontSize ?? baseStyle.fontSize,
        fontWeight: fontWeight ?? baseStyle.fontWeight,
        letterSpacing: baseStyle.letterSpacing,
      ),
    );
  }

  TextStyle _getBaseStyle() {
    switch (textType) {
      case TextType.displayLarge:
        return AppTextStyles.displayLarge;
      case TextType.amountLarge:
        return AppTextStyles.amountLarge;
      case TextType.headlineMedium:
        return AppTextStyles.headlineMedium;
      // --- ADDED: headlineSmall ---
      case TextType.headlineSmall:
        return AppTextStyles.headlineSmall;
      case TextType.bodyMedium:
        return AppTextStyles.bodyMedium;
      // --- ADDED: bodySmall ---
      case TextType.bodySmall:
        return AppTextStyles.bodySmall;
      case TextType.statusOwed:
        return AppTextStyles.statusOwed;
      case TextType.statusOwe:
        return AppTextStyles.statusOwe;
      case TextType.buttonText:
        return AppTextStyles.buttonText;
      default:
        return AppTextStyles.bodyMedium;
    }
  }
}

enum TextType {
  displayLarge,
  amountLarge,
  headlineMedium,
  headlineSmall, // Added to Enum
  bodyMedium,
  bodySmall,    // Added to Enum
  statusOwed,
  statusOwe,
  buttonText,
}