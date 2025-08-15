import 'package:bidan_care/shared/models/bidan_order.dart';
import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:bidan_care/shared/styles/app_text_styles.dart';
import 'package:bidan_care/shared/utils/app_helpers.dart';
import 'package:bidan_care/shared/widgets/default_image.dart';
import 'package:bidan_care/shared/widgets/flat_button.dart';
import 'package:bidan_care/shared/widgets/global_app_bar.dart';
import 'package:flutter/material.dart';

class OrderMasukPage extends StatelessWidget {
  const OrderMasukPage({super.key});

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)!.settings.arguments as BidanOrder;

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
                image: order.gambar,
                height: 96,
                width: 96,
              ),
            ),
            Text(
              order.nama,
              style: AppTextStyles.bodyLarge,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Alamat:\n${order.alamat}"),
                    const SizedBox(height: 32),
                    const Text("Daftar layanan:"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: order.namaLayanan.length,
                itemBuilder: (context, index) {
                  final layanan = order.namaLayanan[index];
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
              text: "Terima",
              onPressed: () => Navigator.pop(context, true),
              width: double.infinity,
            ),
            const SizedBox(height: 4),
            FlatButton(
              text: "Buka Google Maps",
              onPressed: () {
                AppHelpers.redirectGoogleMaps(order.latitude, order.longitude);
              },
              width: double.infinity,
              border: Border.all(color: AppColors.primaryColor),
              color: Colors.white,
              textStyle: const TextStyle(color: AppColors.primaryColor),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32, bottom: 24),
              child: FlatButton(
                text: "Tolak",
                onPressed: () => Navigator.pop(context, false),
                border: Border.all(color: Colors.grey.shade600),
                color: Colors.white,
                width: double.infinity,
                textStyle: TextStyle(color: Colors.grey.shade600),
              ),
            )
          ],
        ),
      ),
    );
  }
}
