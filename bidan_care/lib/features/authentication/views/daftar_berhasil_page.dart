import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:bidan_care/shared/styles/app_text_styles.dart';
import 'package:bidan_care/shared/widgets/flat_button.dart';
import 'package:flutter/material.dart';

class DaftarBerhasilPage extends StatelessWidget {
  const DaftarBerhasilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 72, 32, 0),
        child: Column(
          children: [
            Text(
              "Pembuatan akun berhasil!",
              style: AppTextStyles.headlineMedium.apply(
                color: AppColors.primaryColor,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 27, bottom: 110),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryColor, width: 6),
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 81,
                color: AppColors.primaryColor,
              ),
            ),
            FlatButton(
              text: "Kembali ke Homepage",
              borderRadius: 10,
              width: double.infinity,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
