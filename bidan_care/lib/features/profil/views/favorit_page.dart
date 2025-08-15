import 'dart:developer';

import 'package:bidan_care/core/viewmodels/bidan_view_model.dart';
import 'package:bidan_care/shared/widgets/bidan_item.dart';
import 'package:bidan_care/shared/widgets/loading_bidan_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritPage extends StatefulWidget {
  const FavoritPage({super.key});

  @override
  State<FavoritPage> createState() => _FavoritPageState();
}

class _FavoritPageState extends State<FavoritPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bidan Favorit"),
      ),
      body: FutureBuilder(
        future: context.read<BidanViewModel>().getFavoriteBidan(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // TODO: Loading view
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: 3,
              itemBuilder: (context, index) => const LoadingBidanItem(),
            );
          }
          if (snapshot.hasError) {
            // TODO: error view
            log(snapshot.error.toString());
            return const Text("Terjadi kesalahan");
          }
          if (snapshot.data!.isEmpty) {
            // TODO: empty view
            return const Center(child: Text("Belum ada bidan favorit"));
          }

          final listBidan = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: listBidan.length,
            itemBuilder: (context, index) {
              final bidan = listBidan[index];
              // TODO: setstate on back
              return BidanItem(
                bidan: bidan,
                onBack: (_) => setState(() {}),
              );
            },
          );
        },
      ),
    );
  }
}
