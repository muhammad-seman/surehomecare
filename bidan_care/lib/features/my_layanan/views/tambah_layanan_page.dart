import 'dart:developer';
import 'dart:io';

import 'package:bidan_care/features/my_layanan/models/layanan_baru.dart';
import 'package:bidan_care/features/my_layanan/services/my_layanan_service.dart';
import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:bidan_care/shared/widgets/app_drop_down.dart';
import 'package:bidan_care/shared/widgets/app_text_field.dart';
import 'package:bidan_care/shared/widgets/flat_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class TambahLayananPage extends StatefulWidget {
  const TambahLayananPage({super.key});

  @override
  State<TambahLayananPage> createState() => _TambahLayananPageState();
}

class _TambahLayananPageState extends State<TambahLayananPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _keteranganController = TextEditingController();
  String? _idKategori;
  File? _gambar;

  Future<bool?> _createLayanan() async {
    if (_idKategori == null) return null;
    if (!(_formKey.currentState?.validate() ?? false)) return null;

    final layanan = LayananBaru(
      nama: _namaController.text.trim(),
      harga: int.parse(_hargaController.text),
      idKategori: _idKategori!,
      gambar: _gambar,
      keterangan: _keteranganController.text.trim(),
    );
    return MyLayananService().createLayanan(layanan);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Layanan"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _FotoLayanan(onChanged: (gambar) => _gambar = gambar),
                _KategoriDropdown(
                  onChanged: (id) => _idKategori = id,
                ),
                AppTextField(
                  hint: "Nama Layanan",
                  controller: _namaController,
                  keyboardType: TextInputType.name,
                ),
                AppTextField(
                  hint: "Harga",
                  controller: _hargaController,
                  keyboardType: TextInputType.number,
                ),
                AppTextField(
                  hint: "Keterangan",
                  controller: _keteranganController,
                  isMultiline: true,
                ),
                _SubmitButton(
                  onSubmit: _createLayanan,
                  checkPhoto: () => _gambar != null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FotoLayanan extends StatefulWidget {
  const _FotoLayanan({
    required this.onChanged,
  });

  final Function(File gambar) onChanged;

  @override
  State<_FotoLayanan> createState() => _FotoLayananState();
}

class _FotoLayananState extends State<_FotoLayanan> {
  final _imagePicker = ImagePicker();
  File? _gambar;

  void _changePhoto() async {
    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemp = File(image.path);
      widget.onChanged(imageTemp);
      setState(() => _gambar = imageTemp);
    } on PlatformException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(
        msg: "Terjadi kesalahan",
        backgroundColor: Colors.black87,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.accentColor),
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: _changePhoto,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                _buildImage(),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    "Pilih Gambar",
                    style: TextStyle(color: AppColors.accentColor),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_right,
                  color: AppColors.accentColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (_gambar != null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.file(
          _gambar!,
          width: 48,
          height: 48,
          fit: BoxFit.contain,
        ),
      );
    }

    return const SizedBox(
      width: 48,
      height: 48,
      child: Center(
        child: Icon(
          Icons.photo_outlined,
          size: 35,
          color: AppColors.accentColor,
        ),
      ),
    );
  }
}

class _KategoriDropdown extends StatelessWidget {
  const _KategoriDropdown({required this.onChanged});
  final void Function(String id) onChanged;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MyLayananService().getKategoriLayanan(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          // TODO: error view
          log(snapshot.error.toString());
          return const Text("Terjadi kesalahan");
        }

        final listKategori = snapshot.data!;
        final initialValue = listKategori[0].id;
        onChanged(initialValue);

        return AppDropDown(
          initialValue: initialValue,
          label: "Kategori Layanan",
          items: listKategori.map((kategori) {
            return DropdownMenuItem(
              value: kategori.id,
              child: Text(kategori.nama),
            );
          }).toList(),
          onChanged: (id) => onChanged(id!),
        );
      },
    );
  }
}

class _SubmitButton extends StatefulWidget {
  const _SubmitButton({
    required this.onSubmit,
    required this.checkPhoto,
  });

  final Future<bool?> Function() onSubmit;
  final bool Function() checkPhoto;

  @override
  State<_SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<_SubmitButton> {
  String _error = "";
  bool _isLoading = false;

  void _onSubmit() {
    if (!widget.checkPhoto()) {
      setState(() => _error = "Gambar tidak boleh kosong");
      return;
    }
    setState(() {
      _isLoading = true;
      _error = "";
    });
    widget.onSubmit().then(_postSubmit);
  }

  _postSubmit(bool? success) {
    setState(() {
      _isLoading = false;
      if (success != null && !success) _error = "Terjadi kesalahan";
    });
    if (success ?? false) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _error,
          style: const TextStyle(color: Colors.red),
        ),
        FlatButton(
          text: "Tambah",
          onPressed: _onSubmit,
          enabled: !_isLoading,
          width: double.infinity,
        ),
      ],
    );
  }
}
