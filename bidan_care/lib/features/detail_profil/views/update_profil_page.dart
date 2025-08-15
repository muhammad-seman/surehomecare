import 'package:bidan_care/core/viewmodels/auth_view_model.dart';
import 'package:bidan_care/features/detail_profil/models/update_profil_body.dart';
import 'package:bidan_care/features/detail_profil/services/update_profil_service.dart';
import 'package:bidan_care/shared/widgets/app_text_field.dart';
import 'package:bidan_care/shared/widgets/daerah_form.dart';
import 'package:bidan_care/shared/widgets/default_image.dart';
import 'package:bidan_care/shared/widgets/flat_button.dart';
import 'package:bidan_care/shared/widgets/global_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateProfilPage extends StatelessWidget {
  const UpdateProfilPage({super.key});

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
  final _service = UpdateProfilService();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _noHpController = TextEditingController();
  final _alamatController = TextEditingController();

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
    final email = _emailController.text.trim();
    final noHp = _noHpController.text.trim();
    final alamat = _alamatController.text.trim();

    final profilBidan = UpdateProfilBody(
      nama: nama,
      email: email,
      noHp: noHp,
      idKecamatan: _idKecamatan,
      alamat: alamat,
    );

    _service.updateProfil(profilBidan).then(_postSubmit);
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
    _emailController.text = authViewModel.currentUser!.email;
    _noHpController.text = authViewModel.currentUser!.noHp;
    _alamatController.text = authViewModel.currentUser!.alamat;
    _idKecamatan = authViewModel.currentUser!.kecamatan.id;
  }

  @override
  void dispose() {
    super.dispose();
    _namaController.dispose();
    _emailController.dispose();
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
            hint: "Email",
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          AppTextField(
            hint: "No. HP",
            controller: _noHpController,
            keyboardType: TextInputType.phone,
          ),
          AppTextField(
            hint: "Alamat lengkap",
            controller: _alamatController,
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
