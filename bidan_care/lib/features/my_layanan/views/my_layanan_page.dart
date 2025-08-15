import 'package:bidan_care/core/models/layanan.dart';
import 'package:bidan_care/features/my_layanan/services/my_layanan_service.dart';
import 'package:bidan_care/features/my_layanan/viewmodels/edit_layanan_view_model.dart';
import 'package:bidan_care/routes.dart';
import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:bidan_care/shared/styles/app_text_styles.dart';
import 'package:bidan_care/shared/utils/app_helpers.dart';
import 'package:bidan_care/shared/widgets/default_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyLayananPage extends StatefulWidget {
  const MyLayananPage({super.key});

  @override
  State<MyLayananPage> createState() => _MyLayananPageState();
}

class _MyLayananPageState extends State<MyLayananPage> {
  @override
  Widget build(BuildContext context) {
    final service = MyLayananService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Layanan Anda"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.tambahLayanan)
              .then((_) => setState(() {}));
        },
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: FutureBuilder(
          future: service.getMyLayanan(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                itemCount: 3,
                itemBuilder: (_, __) => const _LoadingLayananItem(),
              );
            }
            if (snapshot.hasError) {
              // TODO: error view
              return const Text("Terjadi kesalahan");
            }

            final listLayanan = snapshot.data!;

            if (listLayanan.isEmpty) {
              return const Center(
                child: Text("Anda belum memiliki layanan"),
              );
            }

            return ListView.builder(
              itemCount: listLayanan.length,
              itemBuilder: (context, index) {
                final layanan = listLayanan[index];
                return _LayananItem(
                  layanan: layanan,
                  refresh: () => setState(() {}),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _LoadingLayananItem extends StatelessWidget {
  const _LoadingLayananItem();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
  const _LayananItem({
    required this.layanan,
    required this.refresh,
  });

  final Layanan layanan;
  final Function() refresh;

  @override
  Widget build(BuildContext context) {
    final String hargaString = AppHelpers.formatHarga(layanan.harga);

    return InkWell(
      onTap: () {
        final viewModel = context.read<EditLayananViewModel>();
        viewModel.openedLayanan = layanan;
        Navigator.pushNamed(context, Routes.editLayanan).then((_) {
          viewModel.openedLayanan = null;
          refresh();
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            DefaultImage(
              image: layanan.gambar,
              borderRadius: 10,
              width: 48,
              height: 48,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(layanan.nama, style: AppTextStyles.bodyLarge),
                  Text(
                    hargaString,
                    style: const TextStyle(color: AppColors.captionColor),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_right,
              color: AppColors.disabledColor,
            ),
          ],
        ),
      ),
    );
  }
}
