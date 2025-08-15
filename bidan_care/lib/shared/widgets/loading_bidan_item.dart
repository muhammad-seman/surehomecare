import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:bidan_care/shared/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class LoadingBidanItem extends StatelessWidget {
  const LoadingBidanItem({super.key});

  @override
  Widget build(BuildContext context) {
    const double imgSize = 72;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: imgSize,
            width: imgSize,
            decoration: BoxDecoration(
              color: AppColors.loadingColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: AppColors.loadingColor,
                    width: 100,
                    child: const Text(
                      "",
                      style: AppTextStyles.titleMedium,
                    ),
                  ),
                  Container(
                    color: AppColors.loadingColor,
                    width: 230,
                    child: Text(
                      "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.apply(
                        color: AppColors.captionColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
