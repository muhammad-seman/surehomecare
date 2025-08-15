import 'package:bidan_care/core/viewmodels/auth_view_model.dart';
import 'package:bidan_care/routes.dart';
import 'package:bidan_care/shared/widgets/foto_profil.dart';
import 'package:bidan_care/shared/widgets/global_app_bar.dart';
import 'package:bidan_care/shared/widgets/profil_info_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailProfilPage extends StatelessWidget {
  const DetailProfilPage({super.key});

  AppBar _buildAppBar(BuildContext context) {
    return GlobalAppBar.transparent(
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.updateProfil);
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

    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: Column(
            children: [
              FotoProfil(gambar: user.gambar),
              const SizedBox(height: 24),
              ProfilInfoItem(
                title: "Nama",
                value: user.nama,
                icon: Icons.person_outline,
              ),
              ProfilInfoItem(
                title: "Email",
                value: user.email,
                icon: Icons.email_outlined,
              ),
              ProfilInfoItem(
                title: "No. HP",
                value: user.noHp,
                icon: Icons.phone_outlined,
              ),
              ProfilInfoItem(
                title: "Kota / Kabupaten",
                value: user.kecamatan.nama,
                icon: Icons.location_on_outlined,
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
