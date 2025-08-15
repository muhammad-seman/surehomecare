import 'package:bidan_care/features/home/views/layanan_item.dart';
import 'package:bidan_care/shared/viewmodels/layanan_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SemuaLayananPage extends StatelessWidget {
  const SemuaLayananPage({super.key});

  @override
  Widget build(BuildContext context) {
    final topLayanan = context.read<LayananViewModel>().topLayanan;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Layanan"),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 3 / 4,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        itemCount: topLayanan.length,
        itemBuilder: (context, index) {
          final layanan = topLayanan[index];
          return LayananItem(layanan: layanan);
        },
      ),
    );
  }
}
