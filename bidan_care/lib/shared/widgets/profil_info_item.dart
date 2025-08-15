import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:flutter/material.dart';

class ProfilInfoItem extends StatelessWidget {
  const ProfilInfoItem({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.centerRow = true,
  });

  final String title;
  final String value;
  final IconData icon;
  final bool centerRow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment:
            centerRow ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                EdgeInsets.only(right: 24, left: 8, top: centerRow ? 0 : 8),
            child: Icon(
              icon,
              color: AppColors.captionColor,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: AppColors.captionColor),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
