import 'dart:developer';

import 'package:bidan_care/core/viewmodels/auth_view_model.dart';
import 'package:bidan_care/features/authentication/viewmodels/daftar_viewmodel.dart';
import 'package:bidan_care/routes.dart';
import 'package:bidan_care/shared/models/user_baru.dart';
import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:bidan_care/shared/styles/app_text_styles.dart';
import 'package:bidan_care/shared/widgets/app_drop_down.dart';
import 'package:bidan_care/shared/widgets/app_text_field.dart';
import 'package:bidan_care/shared/widgets/daerah_form.dart';
import 'package:bidan_care/shared/widgets/flat_button.dart';
import 'package:bidan_care/shared/widgets/global_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DaftarPage extends StatefulWidget {
  const DaftarPage({super.key});

  @override
  State<DaftarPage> createState() => _DaftarPageState();
}

class _DaftarPageState extends State<DaftarPage> {
  static late BuildContext _context;
  final _scrollController = ScrollController();

  Future<String?> _daftar(UserBaru user) {
    return _context.read<AuthViewModel>().daftar(user);
  }

  Future<String?> _submitForm() async {
    try {
      final viewModel = _context.read<DaftarViewModel>();
      final formKey = viewModel.formKey;
      if (!(formKey.currentState?.validate() ?? false)) {
        _scrollController.jumpTo(_scrollController.position.minScrollExtent);
        return "";
      }
      if (viewModel.idKecamatan == null) return "";
      if (viewModel.idProvinsi == null) return "";

      if (viewModel.modeLokasi == "auto") {
        final izin = await viewModel.getLokasiUser();
        if (!izin) return "Perizinan lokasi ditolak";
      }

      final user = UserBaru(
        nama: viewModel.namaController.text.trim(),
        email: viewModel.emailController.text.trim(),
        noHp: viewModel.hpController.text.trim(),
        password: viewModel.passwordController.text,
        latitude: viewModel.lat,
        longitude: viewModel.long,
        idKecamatan: viewModel.idKecamatan!,
        alamat: viewModel.alamatController.text.trim(),
      );
      return await _daftar(user);
    } on KoordinatException catch (e) {
      return e.toString();
    } catch (e) {
      log(e.toString());
      return "Terjadi kesalahan";
    }
  }

  @override
  void dispose() {
    super.dispose();
    final viewModel = context.read<DaftarViewModel>();
    viewModel.namaController.dispose();
    viewModel.emailController.dispose();
    viewModel.hpController.dispose();
    viewModel.passwordController.dispose();
    viewModel.kPasswordController.dispose();
    viewModel.latController.dispose();
    viewModel.longController.dispose();
    viewModel.alamatController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DaftarViewModel()),
      ],
      builder: (context, child) {
        _context = context;
        return Scaffold(
          appBar: GlobalAppBar.hidden(),
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 16),
              child: Form(
                key: context.read<DaftarViewModel>().formKey,
                child: Column(
                  children: [
                    _buildTitle(),
                    const _BioFormSection(),
                    const Divider(height: 57),
                    const _DaerahFormSection(),
                    const _LokasiFormSection(),
                    _SubmitButton(submitForm: _submitForm),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Center _buildTitle() {
    return Center(
      child: Text(
        "iCare",
        style: AppTextStyles.titleLarge.apply(color: AppColors.primaryColor),
      ),
    );
  }
}

class _SubmitButton extends StatefulWidget {
  const _SubmitButton({required this.submitForm});
  final Future<String?> Function() submitForm;

  @override
  State<_SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<_SubmitButton> {
  String _error = "";
  bool _isLoading = false;

  void _submitForm() {
    setState(() {
      _isLoading = true;
      _error = "";
    });
    widget.submitForm().then((error) {
      setState(() => _isLoading = false);
      if (error == null) {
        Navigator.pushReplacementNamed(context, Routes.daftarBerhasil);
        return;
      }
      setState(() => _error = error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(_error, style: const TextStyle(color: Colors.red)),
        FlatButton(
          text: "Buat Akun",
          width: double.infinity,
          onPressed: _submitForm,
          enabled: !_isLoading,
        ),
      ],
    );
  }
}

class _DaerahFormSection extends StatefulWidget {
  const _DaerahFormSection();

  @override
  State<_DaerahFormSection> createState() => _DaerahFormSectionState();
}

class _DaerahFormSectionState extends State<_DaerahFormSection> {
  @override
  Widget build(BuildContext context) {
    return DaerahForm(
      onProvinsiChanged: (idProvinsi) {
        context.read<DaftarViewModel>().idProvinsi = idProvinsi;
      },
      onKecamatanChanged: (idKecamatan) {
        context.read<DaftarViewModel>().idKecamatan = idKecamatan;
      },
    );
  }
}

class _LokasiFormSection extends StatefulWidget {
  const _LokasiFormSection();

  @override
  State<_LokasiFormSection> createState() => _LokasiFormSectionState();
}

class _LokasiFormSectionState extends State<_LokasiFormSection> {
  String _lokasi = "auto";

  @override
  Widget build(BuildContext context) {
    context.read<DaftarViewModel>().modeLokasi = _lokasi;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppDropDown(
          initialValue: _lokasi,
          label: "Lokasi rumah:",
          onChanged: (value) => setState(() => _lokasi = value!),
          items: const [
            DropdownMenuItem(
              value: "auto",
              child: Text("Gunakan lokasi sekarang"),
            ),
            DropdownMenuItem(
              value: "custom",
              child: Text("Custom"),
            ),
          ],
        ),
        Column(
          children: [
            _buildLatLong(),
            AppTextField(
              hint: "Alamat lengkap",
              emptyErrorLabel: "Alamat",
              controller: context.read<DaftarViewModel>().alamatController,
              isMultiline: true,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ],
    );
  }

  Widget _buildLatLong() {
    if (_lokasi == "auto") return const SizedBox();
    return Column(
      children: [
        AppTextField(
          hint: "Latitude",
          controller: context.read<DaftarViewModel>().latController,
          keyboardType: TextInputType.number,
        ),
        AppTextField(
          hint: "Longitude",
          controller: context.read<DaftarViewModel>().longController,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}

class _BioFormSection extends StatelessWidget {
  const _BioFormSection();

  static late BuildContext _context;
  static String? _nama;

  String? _passwordValidator(String? value) {
    final viewModel = _context.read<DaftarViewModel>();

    if (value == null || value.isEmpty) return "Kata sandi tidak boleh kosong";
    if (value.length < 8) return "Kata sandi minimal 8 karakter";
    if (viewModel.passwordController.text !=
        viewModel.kPasswordController.text) {
      return "Kedua password tidak sama";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    _nama ??= ModalRoute.of(context)!.settings.arguments as String? ?? "";
    final viewModel = context.read<DaftarViewModel>();

    viewModel.namaController.text = _nama!;
    final namaWelcome = _nama!.isEmpty ? "ibu" : _nama;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 54, bottom: 8),
          child: Text(
              "Selamat datang $namaWelcome, silahkan isi biodata Ibu di bawah ini:"),
        ),
        AppTextField(
          hint: "Nama Anda",
          emptyErrorLabel: "Nama",
          controller: viewModel.namaController,
          keyboardType: TextInputType.name,
          onChanged: (value) => _nama = value,
        ),
        AppTextField(
          hint: "Email aktif",
          controller: viewModel.emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        AppTextField(
          hint: "Nomor handphone",
          emptyErrorLabel: "No. HP",
          controller: viewModel.hpController,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 24),
        AppTextField(
          hint: "Kata sandi",
          validator: _passwordValidator,
          controller: viewModel.passwordController,
          isPassword: true,
        ),
        AppTextField(
          hint: "Ulangi kata sandi",
          validator: _passwordValidator,
          controller: viewModel.kPasswordController,
          isPassword: true,
        ),
      ],
    );
  }
}
