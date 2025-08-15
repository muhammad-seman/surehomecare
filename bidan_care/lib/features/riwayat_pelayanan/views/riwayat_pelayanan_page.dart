import 'dart:developer';

import 'package:bidan_care/features/riwayat_pelayanan/models/riwayat_pelayanan.dart';
import 'package:bidan_care/features/riwayat_pelayanan/services/riwayat_pelayanan_service.dart';
import 'package:bidan_care/routes.dart';
import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:bidan_care/shared/styles/app_text_styles.dart';
import 'package:bidan_care/shared/utils/app_helpers.dart';
import 'package:bidan_care/shared/widgets/default_image.dart';
import 'package:flutter/material.dart';

class RiwayatPelayananPage extends StatefulWidget {
  const RiwayatPelayananPage({super.key});

  @override
  State<RiwayatPelayananPage> createState() => _RiwayatPelayananPageState();
}

class _RiwayatPelayananPageState extends State<RiwayatPelayananPage> {
  late Future<List<RiwayatPelayanan>> _future;
  final _service = RiwayatPelayananService();

  @override
  void initState() {
    super.initState();
    _future = _service.getRiwayatPelayanan();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // TODO: loading view
          return const Text("Loading...");
        }
        if (snapshot.hasError) {
          // TODO: error view
          log(snapshot.error.toString());
          return const Text("Terjadi kesalahan");
        }
        if (snapshot.data!.isEmpty) {
          // TODO: empty view
          return const SizedBox();
        }

        final listRiwayat = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 18),
          itemCount: listRiwayat.length,
          itemBuilder: (context, index) {
            final riwayat = listRiwayat[index];
            return _RiwayatItem(riwayat: riwayat);
          },
        );
      },
    );
  }
}

class _RiwayatItem extends StatelessWidget {
  const _RiwayatItem({required this.riwayat});
  final RiwayatPelayanan riwayat;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.detailRiwayatPelayanan,
          arguments: riwayat,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            DefaultImage(
              image: riwayat.user.gambar,
              borderRadius: 10,
              height: 64,
              width: 64,
            ),
            const SizedBox(width: 18),
            _buildMetadata(),
          ],
        ),
      ),
    );
  }

  Expanded _buildMetadata() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            riwayat.user.nama,
            style: AppTextStyles.bodyLarge,
          ),
          Text(
            riwayat.user.alamat,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.captionColor),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _buildTglSelesai(riwayat),
          ),
        ],
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
