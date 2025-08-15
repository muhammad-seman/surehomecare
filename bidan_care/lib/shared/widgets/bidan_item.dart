import 'package:bidan_care/core/models/bidan.dart';
import 'package:bidan_care/routes.dart';
import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:bidan_care/shared/styles/app_text_styles.dart';
import 'package:bidan_care/shared/widgets/default_image.dart';
import 'package:flutter/material.dart';

class BidanItem extends StatelessWidget {
  const BidanItem({
    super.key,
    required this.bidan,
    this.onBack,
  });

  final Bidan bidan;
  final Function(dynamic _)? onBack;

  @override
  Widget build(BuildContext context) {
    const double imgSize = 72;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.detailBidan,
          arguments: bidan,
        ).then(onBack ?? (_) {});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThumbnail(bidan, imgSize),
            _buildMetadata(bidan),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(Bidan bidan, double imgSize) {
    return DefaultImage(
      borderRadius: 10,
      image: bidan.thumbnail,
      height: imgSize,
      width: imgSize,
      fit: BoxFit.cover,
    );
  }

  Expanded _buildMetadata(Bidan bidan) {
    final color =
        bidan.bersedia ? AppColors.accentColor : AppColors.captionColor;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bidan.nama,
              style: AppTextStyles.titleMedium,
            ),
            Text(
              bidan.keterangan,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySmall.apply(
                color: AppColors.captionColor,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.cleaning_services,
                  size: 16,
                  color: bidan.bersedia
                      ? AppColors.accentColor
                      : AppColors.disabledColor,
                ),
                const SizedBox(width: 4),
                Text(
                  "${bidan.jlhLayanan} Layanan",
                  style: AppTextStyles.bodySmall.apply(
                    color: color,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "|",
                    style: TextStyle(color: AppColors.dividerColor),
                  ),
                ),
                Text(
                  bidan.bersedia ? "Bersedia" : "Tidak bersedia",
                  style: AppTextStyles.bodySmall.apply(
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
