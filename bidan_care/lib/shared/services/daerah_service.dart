import 'dart:convert';
import 'dart:developer';

import 'package:bidan_care/core/utils/app_constants.dart';
import 'package:bidan_care/shared/models/daerah.dart';
import 'package:http/http.dart' as http;

class DaerahService {
  String get _endpoint => "${AppConstants.baseUrl}/api/daerah";

  Future<List<Daerah>?> getProvinsi() async {
    try {
      final response = await http.get(
        Uri.parse("$_endpoint/provinsi"),
      );
      log("Get provinsi:\n${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["data"] as List;
        final listProvinsi = data.map((e) => Daerah.fromJson(e)).toList();
        return listProvinsi;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<List<Daerah>?> getKecamatan(String idProvinsi) async {
    try {
      final response = await http.get(
        Uri.parse("$_endpoint/kecamatan/$idProvinsi"),
      );
      log("Get kecamatan:\n${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["data"] as List;
        final listKecamatan = data.map((e) => Daerah.fromJson(e)).toList();
        return listKecamatan;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
