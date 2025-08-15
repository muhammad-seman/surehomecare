import 'dart:developer';
import 'dart:io';

import 'package:bidan_care/core/models/layanan.dart';
import 'package:bidan_care/features/my_layanan/models/kategori_layanan.dart';
import 'package:bidan_care/features/my_layanan/models/layanan_baru.dart';
import 'package:bidan_care/features/my_layanan/services/my_layanan_service.dart';
import 'package:bidan_care/features/my_layanan/viewmodels/edit_layanan_view_model.dart';
import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:bidan_care/shared/widgets/alert_modal.dart';
import 'package:bidan_care/shared/widgets/app_drop_down.dart';
import 'package:bidan_care/shared/widgets/app_text_field.dart';
import 'package:bidan_care/shared/widgets/default_image.dart';
import 'package:bidan_care/shared/widgets/flat_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditLayananPage extends StatefulWidget {
  const EditLayananPage({super.key});

  @override
  State<EditLayananPage> createState() => _EditLayananPageState();
}

class _EditLayananPageState extends State<EditLayananPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _keteranganController = TextEditingController();
  String? _idKategori;
  File? _gambar;

  late Layanan _layanan;

  Future<bool?> _editLayanan() async {
    if (_idKategori == null) return null;
    if (!(_formKey.currentState?.validate() ?? false)) return null;

    final layanan = LayananBaru(
      nama: _namaController.text.trim(),
      harga: int.parse(_hargaController.text),
      idKategori: _idKategori!,
      gambar: _gambar,
      keterangan: _keteranganController.text.trim(),
    );
    return MyLayananService().updateLayanan(layanan, _layanan.id);
  }

  @override
  Widget build(BuildContext context) {
    _layanan = context.select<EditLayananViewModel, Layanan>((viewModel) {
      return viewModel.openedLayanan!;
    });
    _namaController.text = _layanan.nama;
    _hargaController.text = _layanan.harga.toString();
    _keteranganController.text = _layanan.keterangan;
    final initialKategori = _layanan.idKategori!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Layanan"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _FotoLayanan(
                  gambarLama: _layanan.gambar,
                  onChanged: (gambar) => _gambar = gambar,
                ),
                _KategoriDropdown(
                  onChanged: (id) => _idKategori = id,
                  initialValue: initialKategori,
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
                _PageActions(
                  onSubmit: _editLayanan,
                  onDelete: () => MyLayananService().deleteLayanan(_layanan.id),
                )
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
    required this.gambarLama,
    required this.onChanged,
  });

  final String gambarLama;
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
                    "Ubah Gambar",
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

    return DefaultImage(
      image: widget.gambarLama,
      borderRadius: 10,
      width: 48,
      height: 48,
      fit: BoxFit.contain,
    );
  }
}

class _KategoriDropdown extends StatefulWidget {
  const _KategoriDropdown({
    required this.onChanged,
    required this.initialValue,
  });

  final void Function(String id) onChanged;
  final String initialValue;

  @override
  State<_KategoriDropdown> createState() => _KategoriDropdownState();
}

class _KategoriDropdownState extends State<_KategoriDropdown> {
  late Future<List<KategoriLayanan>> _future;

  @override
  void initState() {
    super.initState();
    _future = MyLayananService().getKategoriLayanan();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
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
        widget.onChanged(widget.initialValue);

        return AppDropDown(
          initialValue: widget.initialValue,
          label: "Kategori Layanan",
          items: listKategori.map((kategori) {
            return DropdownMenuItem(
              value: kategori.id,
              child: Text(kategori.nama),
            );
          }).toList(),
          onChanged: (id) => widget.onChanged(id!),
        );
      },
    );
  }
}

class _PageActions extends StatefulWidget {
  const _PageActions({
    required this.onSubmit,
    required this.onDelete,
  });

  final Future<bool?> Function() onSubmit;
  final Future<bool?> Function() onDelete;

  @override
  State<_PageActions> createState() => _PageActionsState();
}

class _PageActionsState extends State<_PageActions> {
  String _error = "";
  bool _isLoading = false;

  void _onSubmit() {
    setState(() {
      _isLoading = true;
      _error = "";
    });
    widget.onSubmit().then(_postAction);
  }

  void _requestDelete() async {
    final confirm = await showDialog(
      context: context,
      builder: (context) {
        return const AlertModal(
          title: "Apakah Anda ingin menghapus layanan ini?",
          confirmText: "Hapus",
        );
      },
    );
    if (confirm) widget.onDelete().then(_postAction);
  }

  _postAction(bool? success) {
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
          text: "Hapus",
          onPressed: _requestDelete,
          enabled: !_isLoading,
          width: double.infinity,
          color: Colors.white,
          textStyle: const TextStyle(color: Colors.red),
          border: Border.all(color: Colors.red),
          disabledColor: AppColors.disabledColor,
        ),
        const SizedBox(height: 12),
        FlatButton(
          text: "Update",
          onPressed: _onSubmit,
          enabled: !_isLoading,
          width: double.infinity,
        ),
      ],
    );
  }
}
