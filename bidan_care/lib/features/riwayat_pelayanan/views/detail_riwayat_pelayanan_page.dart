import 'package:bidan_care/features/riwayat_pelayanan/models/riwayat_pelayanan.dart';
import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:bidan_care/shared/styles/app_text_styles.dart';
import 'package:bidan_care/shared/utils/app_helpers.dart';
import 'package:bidan_care/shared/widgets/default_image.dart';
import 'package:bidan_care/shared/widgets/flat_button.dart';
import 'package:bidan_care/shared/widgets/global_app_bar.dart';
import 'package:flutter/material.dart';

class DetailRiwayatPelayananPage extends StatelessWidget {
  const DetailRiwayatPelayananPage({super.key});

  @override
  Widget build(BuildContext context) {
    final riwayat =
        ModalRoute.of(context)!.settings.arguments as RiwayatPelayanan;

    return Scaffold(
      appBar: GlobalAppBar.hidden(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Text(
              "Anda punya pesanan baru",
              style: AppTextStyles.headlineMedium,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32, bottom: 8),
              child: DefaultImage(
                image: riwayat.user.gambar,
                height: 96,
                width: 96,
              ),
            ),
            Text(
              riwayat.user.nama,
              style: AppTextStyles.bodyLarge,
            ),
            _buildTglSelesai(riwayat),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Alamat:\n${riwayat.user.alamat}"),
                    const SizedBox(height: 32),
                    const Text("Daftar layanan:"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: riwayat.listLayanan.length,
                itemBuilder: (context, index) {
                  final layanan = riwayat.listLayanan[index].nama;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      layanan,
                      style: AppTextStyles.bodyLarge,
                    ),
                  );
                },
              ),
            ),
            FlatButton(
              text: "Buka Google Maps",
              onPressed: () {
                AppHelpers.redirectGoogleMaps(
                  riwayat.user.latitude,
                  riwayat.user.longitude,
                );
              },
              width: double.infinity,
              border: Border.all(color: AppColors.primaryColor),
              color: Colors.white,
              textStyle: const TextStyle(color: AppColors.primaryColor),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Text _buildTglSelesai(RiwayatPelayanan riwayat) {
    final colors = {
      "diajukan": AppColors.accentColor,
      "ongoing": const Color(0xFF228B22),
      "ditolak": AppColors.captionColor,
      "dibatal": AppColors.captionColor,
    };
    final weights = {
      "diajukan": FontWeight.bold,
      "ongoing": FontWeight.bold,
      "ditolak": FontWeight.bold,
      "dibatal": FontWeight.normal,
    };

    if (riwayat.status != "selesai") {
      return Text(
        riwayat.statusMessage,
        style: TextStyle(
          fontWeight: weights[riwayat.status],
          color: colors[riwayat.status],
        ),
      );
    }
    return Text(
      AppHelpers.formatTanggal(riwayat.tglSelesai!),
      style: const TextStyle(color: AppColors.captionColor),
    );
  }
}
