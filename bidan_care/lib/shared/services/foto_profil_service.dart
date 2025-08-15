import 'dart:developer';
import 'dart:io';

import 'package:bidan_care/core/utils/app_constants.dart';
import 'package:bidan_care/core/utils/auth_helper.dart';
import 'package:http/http.dart' as http;

class FotoProfilService {
  Future<bool> updateFotoProfil(File gambar) async {
    try {
      final endpoint = "${AppConstants.baseUrl}/api/user/update_foto";
      final token = AuthHelper.token;
      final headers = {"Authorization": "Bearer $token"};

      final request = http.MultipartRequest('PUT', Uri.parse(endpoint));
      request.files.add(await http.MultipartFile.fromPath('file', gambar.path));
      request.headers.addAll(headers);

      final stream = await request.send();
      final response = await http.Response.fromStream(stream);

      log("Update foto profil:\n${response.body}");
      if (response.statusCode == 200) return true;
    } catch (e) {
      log(e.toString());
    }
    return false;
  }

  Future<bool> hapusFotoProfil() async {
    try {
      final endpoint = "${AppConstants.baseUrl}/api/user/hapus_foto";
      final token = AuthHelper.token;
      final response = await http.delete(
        Uri.parse(endpoint),
        headers: {"Authorization": "Bearer $token"},
      );

      log("Hapus foto profil:\n${response.body}");
      if (response.statusCode == 200) return true;
    } catch (e) {
      log(e.toString());
    }
    return false;
  }
}
