import 'package:bidan_care/features/home/models/top_layanan.dart';
import 'package:bidan_care/shared/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class LayananItem extends StatelessWidget {
  const LayananItem({super.key, required this.layanan});
  final TopLayanan layanan;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      // TODO: ke halaman hasil pencarian dengan filter layanan
      onPressed: () {},
      minWidth: 0,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              layanan.gambar,
              fit: BoxFit.cover,
              height: 56,
              width: 56,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 64,
            child: Text(
              layanan.nama,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
