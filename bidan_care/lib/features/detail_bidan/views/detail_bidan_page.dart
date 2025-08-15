import 'dart:developer';

import 'package:bidan_care/core/models/bidan.dart';
import 'package:bidan_care/core/models/layanan.dart';
import 'package:bidan_care/core/viewmodels/bidan_view_model.dart';
import 'package:bidan_care/features/detail_bidan/models/order_response.dart';
import 'package:bidan_care/features/detail_bidan/viewmodels/detail_bidan_viewmodel.dart';
import 'package:bidan_care/features/messages/models/oppose_user.dart';
import 'package:bidan_care/routes.dart';
import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:bidan_care/shared/styles/app_text_styles.dart';
import 'package:bidan_care/shared/utils/app_helpers.dart';
import 'package:bidan_care/shared/widgets/default_image.dart';
import 'package:bidan_care/shared/widgets/flat_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailBidanPage extends StatelessWidget {
  const DetailBidanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Bidan bidan = ModalRoute.of(context)!.settings.arguments as Bidan;

    return ChangeNotifierProvider(
      create: (_) => DetailBidanViewmodel(bidan),
      child: const Scaffold(
        bottomNavigationBar: _PageActions(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  _PageHeader(),
                  _PageContent(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PageActions extends StatefulWidget {
  const _PageActions();

  @override
  State<_PageActions> createState() => _PageActionsState();
}

class _PageActionsState extends State<_PageActions> {
  bool _isLoading = false;
  String? _error;

  void _pesanBidan() {
    setState(() {
      _isLoading = true;
      _error = "";
    });
    context.read<DetailBidanViewmodel>().createOrder().then(_postPesanBidan);
  }

  void _postPesanBidan(OrderResponse response) {
    setState(() {
      _isLoading = false;
      _error = response.error;
    });
    if (response.error == null) {
      final bidan = context.read<DetailBidanViewmodel>().bidan;
      final opposeUser = OpposeUser(
        id: bidan.id,
        nama: bidan.nama,
        gambar: bidan.thumbnail,
      );
      Navigator.pushNamed(context, Routes.pesanBerhasil, arguments: opposeUser);
    }
    if (response.fetchBidan) context.read<BidanViewModel>().getBidan();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 12, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -5),
            blurRadius: 10,
            color: Colors.black12,
          ),
        ],
      ),
      child: Consumer<DetailBidanViewmodel>(builder: (_, viewModel, __) {
        final selectedLayanan = viewModel.selectedLayanan;
        bool enabled = selectedLayanan.isNotEmpty;
        if (_isLoading) enabled = false;
        if (!viewModel.bidan.bersedia) enabled = false;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildErrorText(),
            const SizedBox(height: 8),
            Row(
              children: [
                _metadataBuilder(selectedLayanan),
                const Expanded(child: SizedBox()),
                FlatButton(
                  text: "Pesan",
                  border: Border.all(color: AppColors.primaryColor),
                  disabledColor: AppColors.disabledColor,
                  enabled: enabled,
                  onPressed: _pesanBidan,
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildErrorText() {
    if (_error == null) return const SizedBox();
    return Text(
      _error!,
      style: const TextStyle(color: Colors.red),
    );
  }

  Widget _metadataBuilder(List<Layanan> selectedLayanan) {
    final int jlhLayanan = selectedLayanan.length;
    final Iterable<int> listHarga = selectedLayanan.map((e) => e.harga);
    final int totalHarga =
        selectedLayanan.isEmpty ? 0 : listHarga.reduce((v, e) => v + e);
    final String totalString = AppHelpers.formatHarga(totalHarga);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("$jlhLayanan layanan terpilih", style: AppTextStyles.bodyLarge),
        Text(
          totalString,
          style: const TextStyle(color: AppColors.captionColor),
        ),
      ],
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.white),
            ),
            icon: const Icon(Icons.arrow_back),
          ),
          const _FavoriteButton(),
        ],
      ),
    );
  }
}

class _PageContent extends StatelessWidget {
  const _PageContent();

  @override
  Widget build(BuildContext context) {
    final bidan = context.read<DetailBidanViewmodel>().bidan;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: DefaultImage(
              borderRadius: 20,
              image: bidan.thumbnail,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text(bidan.nama, style: AppTextStyles.headlineMedium),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            bidan.bersedia ? "Bersedia" : "Tidak bersedia",
            style: TextStyle(
                color: bidan.bersedia
                    ? Colors.green.shade600
                    : Colors.red.shade400),
          ),
        ),
        Text(bidan.keterangan),
        const Padding(
          padding: EdgeInsets.only(top: 32, bottom: 12),
          child: Text("Layanan", style: AppTextStyles.headlineSmall),
        ),
        FutureBuilder(
          future: context.read<DetailBidanViewmodel>().getBidanDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (_, __) => const _LoadingLayananItem(),
              );
            }

            if (snapshot.hasError || !snapshot.hasData) {
              log("Error: ${snapshot.error}");
              log("Has data: ${snapshot.hasData}");
              // TODO: error view
              // TODO: empty view
              return const Text("Terjadi kesalahan");
            }

            final listLayanan = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: listLayanan.length,
              itemBuilder: (context, index) {
                final layanan = listLayanan[index];
                return _LayananItem(layanan: layanan);
              },
            );
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _LoadingLayananItem extends StatelessWidget {
  const _LoadingLayananItem();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 12, 8),
      child: Row(
        children: [
          Container(
            height: 64,
            width: 64,
            margin: const EdgeInsets.only(right: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.loadingColor,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  margin: const EdgeInsets.only(bottom: 4),
                  color: AppColors.loadingColor,
                  child: Text(
                    "",
                    style: AppTextStyles.bodyLarge
                        .apply(color: AppColors.loadingColor),
                  ),
                ),
                Container(
                  width: 100,
                  color: AppColors.loadingColor,
                  child: Text(
                    "",
                    style: TextStyle(color: AppColors.loadingColor),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _LayananItem extends StatelessWidget {
  const _LayananItem({required this.layanan});
  final Layanan layanan;

  @override
  Widget build(BuildContext context) {
    final String hargaString = AppHelpers.formatHarga(layanan.harga);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 12, 8),
      child: Row(
        children: [
          DefaultImage(
            image: layanan.gambar,
            borderRadius: 10,
            width: 64,
            height: 64,
            fit: BoxFit.contain,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(layanan.nama, style: AppTextStyles.bodyLarge),
                  Text(
                    hargaString,
                    style: const TextStyle(color: AppColors.captionColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    layanan.keterangan,
                    style: const TextStyle(color: AppColors.captionColor),
                  ),
                ],
              ),
            ),
          ),
          Consumer<DetailBidanViewmodel>(
            builder: (context, viewModel, child) {
              final bool isSelected =
                  viewModel.selectedLayanan.contains(layanan);

              return Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppColors.primaryColor : Colors.white,
                    border: Border.all(color: AppColors.primaryColor),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () {
                      context.read<DetailBidanViewmodel>().toggleItem(layanan);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        isSelected ? Icons.remove : Icons.add,
                        color:
                            isSelected ? Colors.white : AppColors.primaryColor,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FavoriteButton extends StatefulWidget {
  const _FavoriteButton();

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton> {
  bool _isFavorite = false;

  DetailBidanViewmodel get _viewModel => context.read<DetailBidanViewmodel>();

  void _toggleFavorite() async {
    _viewModel.setFavoriteBidan(!_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    _isFavorite = context.select<DetailBidanViewmodel, bool>(
        (viewModel) => viewModel.isFavorite);
    final IconData icon = _isFavorite ? Icons.favorite : Icons.favorite_border;

    return IconButton(
      onPressed: _toggleFavorite,
      style: const ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.white),
      ),
      icon: Icon(icon),
    );
  }
}
