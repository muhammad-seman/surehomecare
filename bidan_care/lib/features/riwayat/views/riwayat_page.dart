import 'dart:developer';

import 'package:bidan_care/features/riwayat/models/riwayat.dart';
import 'package:bidan_care/features/riwayat/services/riwayat_service.dart';
import 'package:bidan_care/shared/models/riwayat_layanan.dart';
import 'package:bidan_care/routes.dart';
import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:bidan_care/shared/styles/app_text_styles.dart';
import 'package:bidan_care/shared/utils/app_helpers.dart';
import 'package:bidan_care/shared/widgets/default_image.dart';
import 'package:flutter/material.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  void _onPressed(Riwayat riwayat) {
    Navigator.pushNamed(
      context,
      Routes.detailRiwayat,
      arguments: riwayat,
    ).then((value) {
      if (value == true) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RiwayatService().getRiwayat(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 18),
            itemCount: 3,
            itemBuilder: (_, __) => const _LoadingRiwayatItem(),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          log(snapshot.error.toString());
          // TODO: error view
          // TODO: empty view
          return const Text("Terjadi kesalahan");
        }

        final listRiwayat = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 18),
          itemCount: listRiwayat.length,
          itemBuilder: (context, index) {
            final riwayat = listRiwayat[index];
            return _RiwayatItem(
              riwayat: riwayat,
              onPressed: _onPressed,
            );
          },
        );
      },
    );
  }
}

class _LoadingRiwayatItem extends StatelessWidget {
  const _LoadingRiwayatItem();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            margin: const EdgeInsets.only(right: 18),
            decoration: BoxDecoration(
              color: AppColors.loadingColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          _buildLoadingMetadata(),
        ],
      ),
    );
  }

  Expanded _buildLoadingMetadata() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            color: AppColors.loadingColor,
            child: const Text(
              "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyLarge,
            ),
          ),
          Container(
            width: 100,
            color: AppColors.loadingColor,
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: const Text(
              "",
              style: TextStyle(color: AppColors.captionColor),
            ),
          ),
          Container(
            width: 80,
            color: AppColors.loadingColor,
            child: const Text(
              "",
              style: TextStyle(color: AppColors.captionColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _RiwayatItem extends StatelessWidget {
  const _RiwayatItem({
    required this.riwayat,
    required this.onPressed,
  });

  final Riwayat riwayat;
  final Function(Riwayat riwayat) onPressed;

  @override
  Widget build(BuildContext context) {
    final layanan = riwayat.listLayanan[0];
    return InkWell(
      onTap: () => onPressed(riwayat),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            DefaultImage(
              image: riwayat.bidan?.thumbnail,
              borderRadius: 10,
              height: 64,
              width: 64,
            ),
            const SizedBox(width: 18),
            _buildRiwayatMetadata(layanan, riwayat),
          ],
        ),
      ),
    );
  }

  Widget _buildRiwayatMetadata(RiwayatLayanan layanan, Riwayat riwayat) {
    final Iterable<int> listHarga = riwayat.listLayanan.map((e) => e.jlhBayar);
    final int totalHarga = listHarga.reduce((v, e) => v + e);
    final Iterable<String> listNamaLayanan =
        riwayat.listLayanan.map((e) => e.nama);
    final String semuaLayanan = listNamaLayanan.reduce((v, e) => "$v, $e");

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            semuaLayanan,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyLarge,
          ),
          Text(
            riwayat.bidan?.nama ?? "Bidan terhapus",
            style: const TextStyle(color: AppColors.captionColor),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppHelpers.formatHarga(totalHarga),
                style: const TextStyle(color: AppColors.captionColor),
              ),
              _buildTglSelesai(riwayat),
            ],
          ),
        ],
      ),
    );
  }

  Text _buildTglSelesai(Riwayat riwayat) {
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
