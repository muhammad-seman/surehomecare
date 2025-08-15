import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bidan_care/core/models/layanan.dart';
import 'package:bidan_care/core/utils/app_constants.dart';
import 'package:bidan_care/core/utils/auth_helper.dart';
import 'package:bidan_care/features/my_layanan/models/kategori_layanan.dart';
import 'package:bidan_care/features/my_layanan/models/layanan_baru.dart';
import 'package:http/http.dart' as http;

class MyLayananService {
  String get _endpoint => "${AppConstants.baseUrl}/api/layanan";

  Future<List<KategoriLayanan>> getKategoriLayanan() async {
    final response = await http.get(
      Uri.parse("$_endpoint/kategori"),
      headers: {"Authorization": "Bearer ${AuthHelper.token}"},
    );
    log("Get kategori layanan: ${response.body}");
    if (response.statusCode != 200) throw Exception("API Error");
    final data = jsonDecode(response.body)["data"] as List;
    return data.map((e) => KategoriLayanan.fromJson(e)).toList();
  }

  Future<List<Layanan>> getMyLayanan() async {
    final response = await http.get(
      Uri.parse(_endpoint),
      headers: {"Authorization": "Bearer ${AuthHelper.token}"},
    );
    log("Get my layanan: ${response.body}");
    if (response.statusCode != 200) throw Exception("API Error");
    final data = jsonDecode(response.body)["data"] as List;
    return data.map((e) => Layanan.fromJson(e)).toList();
  }

  Future<bool> createLayanan(LayananBaru layanan) async {
    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          "Authorization": "Bearer ${AuthHelper.token}",
          "Content-Type": "application/json"
        },
        body: layanan.toJson(),
      );
      log("Create layanan: ${response.body}");
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body)["data"];
        final id = data["id"];
        return await uploadGambarLayanan(id, layanan.gambar!);
      }
    } catch (e) {
      log(e.toString());
    }
    return false;
  }

  Future<bool> updateLayanan(LayananBaru layanan, String id) async {
    try {
      bool uploadGambar = true;
      if (layanan.gambar != null) {
        uploadGambar = await uploadGambarLayanan(id, layanan.gambar!);
      }
      if (!uploadGambar) return false;
      final response = await http.put(
        Uri.parse("$_endpoint/$id"),
        headers: {
          "Authorization": "Bearer ${AuthHelper.token}",
          "Content-Type": "application/json"
        },
        body: layanan.toJson(),
      );
      log("Update layanan: ${response.body}");
      if (response.statusCode == 200) return true;
    } catch (e) {
      log(e.toString());
    }
    return false;
  }

  Future<bool> uploadGambarLayanan(String id, File gambar) async {
    try {
      final endpoint = "$_endpoint/upload_gambar/$id";
      final token = AuthHelper.token;
      final headers = {"Authorization": "Bearer $token"};

      final request = http.MultipartRequest('PUT', Uri.parse(endpoint));
      request.files.add(await http.MultipartFile.fromPath('file', gambar.path));
      request.headers.addAll(headers);

      final stream = await request.send();
      final response = await http.Response.fromStream(stream);

      log("Update gambar produk:\n${response.body}");
      if (response.statusCode == 200) return true;
    } catch (e) {
      log(e.toString());
    }
    return false;
  }

  Future<bool> deleteLayanan(String id) async {
    try {
      final response = await http.delete(
        Uri.parse("$_endpoint/$id"),
        headers: {"Authorization": "Bearer ${AuthHelper.token}"},
      );
      log("Delete layanan: ${response.body}");
      if (response.statusCode == 200) return true;
    } catch (e) {
      log(e.toString());
    }
    return false;
  }
}
