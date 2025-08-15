import 'package:bidan_care/core/viewmodels/auth_view_model.dart';
import 'package:bidan_care/routes.dart';
import 'package:bidan_care/shared/viewmodels/profil_bidan_view_model.dart';
import 'package:bidan_care/shared/widgets/foto_profil.dart';
import 'package:bidan_care/shared/widgets/global_app_bar.dart';
import 'package:bidan_care/shared/widgets/profil_info_item.dart';
import 'package:bidan_care/shared/widgets/profil_switch_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilBidanPage extends StatelessWidget {
  const ProfilBidanPage({super.key});

  AppBar _buildAppBar(BuildContext context) {
    return GlobalAppBar.transparent(
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.updateProfilBidan);
            },
            icon: const Icon(Icons.edit),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthViewModel>().currentUser!;
    final bidan = context.watch<AuthViewModel>().profilBidan!;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: Column(
            children: [
              FotoProfil(gambar: user.gambar),
              const SizedBox(height: 24),
              ProfilSwitchItem(
                title: "Bersedia:",
                initialValue: bidan.bersedia,
                onChanged: context.read<ProfilBidanViewModel>().updateKesediaan,
              ),
              ProfilInfoItem(
                title: "Nama",
                value: user.nama,
                icon: Icons.person_outline,
              ),
              ProfilInfoItem(
                title: "Keterangan",
                value: bidan.keterangan,
                icon: Icons.info_outline,
                centerRow: false,
              ),
              ProfilInfoItem(
                title: "Kota / Kabupaten",
                value: user.kecamatan.nama,
                icon: Icons.location_on_outlined,
                centerRow: false,
              ),
              ProfilInfoItem(
                title: "Alamat",
                value: user.alamat,
                icon: Icons.home_outlined,
                centerRow: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
