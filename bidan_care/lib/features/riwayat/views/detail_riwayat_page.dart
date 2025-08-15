import 'package:bidan_care/features/riwayat/models/riwayat.dart';
import 'package:bidan_care/features/riwayat/services/riwayat_service.dart';
import 'package:bidan_care/shared/models/riwayat_layanan.dart';
import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:bidan_care/shared/styles/app_text_styles.dart';
import 'package:bidan_care/shared/utils/app_helpers.dart';
import 'package:bidan_care/shared/widgets/default_layanan_image.dart';
import 'package:bidan_care/shared/widgets/flat_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailRiwayatPage extends StatelessWidget {
  const DetailRiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Riwayat riwayat =
        ModalRoute.of(context)!.settings.arguments as Riwayat;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _PageTitle(riwayat: riwayat),
            _LayananListView(listLayanan: riwayat.listLayanan),
            _TotalContainer(listLayanan: riwayat.listLayanan),
            _SelesaiButton(riwayat: riwayat),
          ],
        ),
      ),
    );
  }
}

class _SelesaiButton extends StatefulWidget {
  const _SelesaiButton({required this.riwayat});
  final Riwayat riwayat;

  @override
  State<_SelesaiButton> createState() => _SelesaiButtonState();
}

class _SelesaiButtonState extends State<_SelesaiButton> {
  bool _isLoading = false;
  String _error = "";

  void _selesaikanPesanan() {
    setState(() {
      _isLoading = true;
      _error = "";
    });
    RiwayatService()
        .selesaikanPesanan(widget.riwayat.id)
        .then(_postSelesaikanPesanan);
  }

  _postSelesaikanPesanan(bool success) {
    if (success) Navigator.pop(context, true);
    setState(() {
      _isLoading = false;
      if (!success) _error = "Terjadi kesalahan";
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.riwayat.status != "ongoing") return const SizedBox();

    return Column(
      children: [
        const SizedBox(height: 52),
        Text(
          _error,
          style: const TextStyle(color: Colors.red),
        ),
        FlatButton(
          text: "Selesaikan Pesanan",
          onPressed: _selesaikanPesanan,
          enabled: !_isLoading,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _PageTitle extends StatelessWidget {
  const _PageTitle({required this.riwayat});
  final Riwayat riwayat;

  String get _tanggalString {
    if (riwayat.status == "ongoing") return "Ongoing";
    if (riwayat.status == "selesai") {
      return DateFormat("dd/MM/yyyy hh:mm").format(riwayat.tglSelesai!);
    }
    return "-";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(27, 0, 27, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _tanggalString,
            style: AppTextStyles.headlineMedium.apply(
              color: AppColors.primaryColor,
            ),
          ),
          Text(
            riwayat.bidan?.nama ?? "Bidan terhapus",
            style: AppTextStyles.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _LayananListView extends StatelessWidget {
  const _LayananListView({required this.listLayanan});
  final List<RiwayatLayanan> listLayanan;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Layanan", style: AppTextStyles.headlineSmall),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: listLayanan.length,
            itemBuilder: (context, index) {
              final layanan = listLayanan[index];
              return _LayananItem(layanan: layanan);
            },
          ),
        ],
      ),
    );
  }
}

class _LayananItem extends StatelessWidget {
  const _LayananItem({required this.layanan});
  final RiwayatLayanan layanan;

  @override
  Widget build(BuildContext context) {
    final String hargaString = AppHelpers.formatHarga(layanan.jlhBayar);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          DefaultLayananImage(
            image: layanan.gambar,
            height: 64,
            width: 64,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(layanan.nama, style: AppTextStyles.bodyLarge),
              Text(
                hargaString,
                style: const TextStyle(color: AppColors.captionColor),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _TotalContainer extends StatelessWidget {
  const _TotalContainer({required this.listLayanan});
  final List<RiwayatLayanan> listLayanan;

  @override
  Widget build(BuildContext context) {
    final Iterable<int> listHarga = listLayanan.map((e) => e.jlhBayar);
    final int totalHarga = listHarga.reduce((v, e) => v + e);
    final String totalString = AppHelpers.formatHarga(totalHarga);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border.symmetric(
          horizontal: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Total"),
          Text(totalString, style: AppTextStyles.titleLarge),
        ],
      ),
    );
  }
}
