import 'dart:convert';
import 'dart:developer';

import 'package:bidan_care/core/utils/app_constants.dart';
import 'package:bidan_care/core/utils/auth_helper.dart';
import 'package:bidan_care/features/riwayat_pelayanan/models/riwayat_pelayanan.dart';
import 'package:http/http.dart' as http;

class RiwayatPelayananService {
  String get _endpoint => "${AppConstants.baseUrl}/api/order";

  Future<List<RiwayatPelayanan>> getRiwayatPelayanan() async {
    final response = await http.get(
      Uri.parse("$_endpoint/riwayat_pelayanan"),
      headers: {"Authorization": "Bearer ${AuthHelper.token}"},
    );
    log("Get riwayat pelayanan: ${response.body}");
    if (response.statusCode != 200) throw Exception("API Error");
    final data = jsonDecode(response.body)["data"] as List;
    return data.map((e) => RiwayatPelayanan.fromJson(e)).toList();
  }
}
