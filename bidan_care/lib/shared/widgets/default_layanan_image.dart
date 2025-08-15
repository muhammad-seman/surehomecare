import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:flutter/material.dart';

class DefaultLayananImage extends StatelessWidget {
  const DefaultLayananImage({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 999,
  });

  final String? image;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: AppColors.primaryColor),
        ),
        child: const Center(
          child: Icon(
            Icons.cleaning_services,
            color: AppColors.primaryColor,
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        image!,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }
}
