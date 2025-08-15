import 'dart:convert';
import 'dart:developer';

import 'package:bidan_care/core/utils/app_constants.dart';
import 'package:bidan_care/core/utils/auth_helper.dart';
import 'package:bidan_care/features/riwayat/models/riwayat.dart';
import 'package:http/http.dart' as http;

class RiwayatService {
  String get _endpoint => "${AppConstants.baseUrl}/api/order";

  Future<List<Riwayat>> getRiwayat() async {
    final response = await http.get(
      Uri.parse("$_endpoint/riwayat"),
      headers: {"Authorization": "Bearer ${AuthHelper.token}"},
    );
    log("Get riwayat: ${response.body}");
    if (response.statusCode != 200) throw Exception("API Error");
    final data = jsonDecode(response.body)["data"] as List;
    return data.map((e) => Riwayat.fromJson(e)).toList();
  }

  Future<bool> selesaikanPesanan(String id) async {
    try {
      final url = "$_endpoint/update_status/$id";
      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${AuthHelper.token}",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"status": "selesai"}),
      );
      log("Update order status: ${response.body}");
      if (response.statusCode == 200) return true;
    } catch (e) {
      log(e.toString());
    }
    return false;
  }
}
