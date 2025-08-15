import 'package:bidan_care/core/viewmodels/auth_view_model.dart';
import 'package:bidan_care/shared/models/profil_bidan_body.dart';
import 'package:bidan_care/shared/viewmodels/profil_bidan_view_model.dart';
import 'package:bidan_care/shared/widgets/app_text_field.dart';
import 'package:bidan_care/shared/widgets/daerah_form.dart';
import 'package:bidan_care/shared/widgets/default_image.dart';
import 'package:bidan_care/shared/widgets/flat_button.dart';
import 'package:bidan_care/shared/widgets/global_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateProfilBidanPage extends StatelessWidget {
  const UpdateProfilBidanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthViewModel>().currentUser!;

    return Scaffold(
      appBar: GlobalAppBar.transparent(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: Column(
            children: [
              DefaultImage(
                image: user.gambar,
                width: 96,
                height: 96,
              ),
              const SizedBox(height: 24),
              const _PageForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageForm extends StatefulWidget {
  const _PageForm();

  @override
  State<_PageForm> createState() => _PageFormState();
}

class _PageFormState extends State<_PageForm> {
  final _namaController = TextEditingController();
  final _keteranganController = TextEditingController();

  bool _isLoading = false;
  String _error = "";
  late String _idKecamatan;

  AuthViewModel get authViewModel => context.read<AuthViewModel>();

  void _onSubmit() {
    setState(() {
      _isLoading = true;
      _error = "";
    });
    final nama = _namaController.text.trim();
    final keterangan = _keteranganController.text.trim();

    final profilBidan = ProfilBidanBody(
      nama: nama,
      keterangan: keterangan,
      idKecamatan: _idKecamatan,
    );

    context
        .read<ProfilBidanViewModel>()
        .updateProfil(profilBidan)
        .then(_postSubmit);
  }

  _postSubmit(String? error) {
    setState(() {
      _isLoading = false;
      _error = error ?? "";
    });
    if (error == null) {
      authViewModel.getProfile();
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _namaController.text = authViewModel.currentUser!.nama;
    _keteranganController.text = authViewModel.profilBidan!.keterangan;
    _idKecamatan = authViewModel.currentUser!.kecamatan.id;
  }

  @override
  void dispose() {
    super.dispose();
    _namaController.dispose();
    _keteranganController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          AppTextField(
            hint: "Nama",
            controller: _namaController,
            keyboardType: TextInputType.name,
          ),
          AppTextField(
            hint: "Keterangan",
            controller: _keteranganController,
            isMultiline: true,
          ),
          DaerahForm(
            initProvinsi: authViewModel.currentUser!.provinsi.id,
            initKecamatan: authViewModel.currentUser!.kecamatan.id,
            onKecamatanChanged: (idKecamatan) => _idKecamatan = idKecamatan,
          ),
          const SizedBox(height: 12),
          Text(
            _error,
            style: const TextStyle(color: Colors.red),
          ),
          FlatButton(
            text: "Simpan",
            onPressed: _onSubmit,
            enabled: !_isLoading,
            width: double.infinity,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
