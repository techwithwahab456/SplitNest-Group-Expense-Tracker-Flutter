import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constant/app_colors.dart';

enum ImageType { network, asset, file, memory }

class Wroundedimage2 extends StatelessWidget {
  final double? width, height;
  final double borderRadius;
  final BoxFit fit;
  final String? image;
  final File? file;
  final Uint8List? bytes;
  final ImageType imageType;
  final VoidCallback? ontap;

  const Wroundedimage2({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 15,
    this.fit = BoxFit.cover,
    this.image,
    this.file,
    this.bytes,
    this.ontap,
    required this.imageType,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: width ?? 60.w,
        height: height ?? 60.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius.r),
          color: AppColors.surfaceColor,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius.r),
          child: _buildImageWidget(),
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    switch (imageType) {
      case ImageType.network:
        return image != null && image!.isNotEmpty
            ? Image.network(image!, fit: fit, errorBuilder: (_, __, ___) => const Icon(Icons.person, color: Colors.grey))
            : const Icon(Icons.broken_image, color: Colors.red);
      case ImageType.asset:
        return Image.asset(image!, fit: fit);
      case ImageType.file:
        return Image.file(file!, fit: fit);
      case ImageType.memory:
        return Image.memory(bytes!, fit: fit);
    }
  }
}