import 'package:bidan_care/features/profil/models/lokasi_tersimpan.dart';
import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:bidan_care/shared/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class LokasiTersimpanPage extends StatelessWidget {
  const LokasiTersimpanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lokasi Tersimpan"),
      ),
      body: ListView.builder(
        // TODO: dummy lokasi tersimpan
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: dummyLokasiTersimpan.length,
        itemBuilder: (context, index) {
          final lokasi = dummyLokasiTersimpan[index];
          return _LokasiItem(lokasi: lokasi);
        },
      ),
    );
  }
}

class _LokasiItem extends StatelessWidget {
  const _LokasiItem({required this.lokasi});
  final LokasiTersimpan lokasi;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: AppColors.primaryColor),
              ),
              child: const Icon(
                Icons.location_on,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lokasi.nama,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleMedium,
                  ),
                  Text(
                    "${lokasi.latitude}, ${lokasi.longitude}",
                    style: AppTextStyles.bodySmall.apply(
                      color: AppColors.captionColor,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_right,
              size: 20,
              color: AppColors.disabledColor,
            ),
          ],
        ),
      ),
    );
  }
}
