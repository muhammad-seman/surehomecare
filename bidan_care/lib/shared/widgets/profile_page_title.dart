import 'package:bidan_care/core/viewmodels/auth_view_model.dart';
import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:bidan_care/shared/styles/app_text_styles.dart';
import 'package:bidan_care/shared/widgets/default_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePageTitle extends StatelessWidget {
  const ProfilePageTitle({
    super.key,
    this.margin = const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 24,
    ),
  });

  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthViewModel>().currentUser!;

    return Padding(
      padding: margin,
      child: Row(
        children: [
          DefaultImage(
            image: user.gambar,
            height: 64,
            width: 64,
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.nama,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyLarge,
                ),
                Text(
                  user.kecamatan.nama,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.captionColor),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
