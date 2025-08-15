import 'package:flutter/material.dart';

class DefaultImage extends StatelessWidget {
  const DefaultImage({
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

  ImageProvider get imageProvider {
    if (image != null) {
      return NetworkImage(image!);
    }
    return const AssetImage("assets/images/bidan_icon.png");
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image(
        image: imageProvider,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }
}
