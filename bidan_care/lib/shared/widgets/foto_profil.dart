import 'dart:developer';
import 'dart:io';

import 'package:bidan_care/core/viewmodels/auth_view_model.dart';
import 'package:bidan_care/shared/services/foto_profil_service.dart';
import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:bidan_care/shared/styles/app_text_styles.dart';
import 'package:bidan_care/shared/widgets/default_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FotoProfil extends StatefulWidget {
  const FotoProfil({super.key, required this.gambar});
  final String? gambar;

  @override
  State<FotoProfil> createState() => _FotoProfilState();
}

class _FotoProfilState extends State<FotoProfil> {
  final _imagePicker = ImagePicker();
  final _service = FotoProfilService();

  void _fotoAction() async {
    if (widget.gambar == null) {
      _changeFoto();
      return;
    }
    final action = await showDialog(
      context: context,
      builder: (context) {
        return const _FotoActionModal();
      },
    );
    if (action == "ubah") _changeFoto();
    if (action == "hapus") _hapusFoto();
  }

  void _hapusFoto() {
    _service.hapusFotoProfil().then(_postActionFoto);
  }

  void _changeFoto() async {
    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemp = File(image.path);
      _service.updateFotoProfil(imageTemp).then(_postActionFoto);
    } on PlatformException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(
        msg: "Terjadi kesalahan",
        backgroundColor: Colors.black87,
        textColor: Colors.white,
      );
    }
  }

  _postActionFoto(bool success) {
    if (!success) {
      Fluttertoast.showToast(
        msg: "Terjadi kesalahan",
        backgroundColor: Colors.black87,
        textColor: Colors.white,
      );
      return;
    }
    Fluttertoast.showToast(
      msg: "Berhasil mengubah foto profil",
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
    context.read<AuthViewModel>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      width: 130,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: DefaultImage(
              image: widget.gambar,
              width: 96,
              height: 96,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accentColor),
              ),
              child: IconButton(
                onPressed: _fotoAction,
                icon: const Icon(Icons.file_upload_outlined),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FotoActionModal extends StatelessWidget {
  const _FotoActionModal();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () => Navigator.pop(context, "ubah"),
            leading: const Icon(
              Icons.edit_outlined,
              color: AppColors.primaryColor,
            ),
            title: Text(
              "Ubah Foto Profil",
              style: AppTextStyles.bodyMedium.apply(
                color: AppColors.primaryColor,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.delete_outline,
              color: Colors.red.shade400,
            ),
            onTap: () => Navigator.pop(context, "hapus"),
            title: Text(
              "Hapus Foto Profil",
              style: AppTextStyles.bodyMedium.apply(
                color: Colors.red.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
