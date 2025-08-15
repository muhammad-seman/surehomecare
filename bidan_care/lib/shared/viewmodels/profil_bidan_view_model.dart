import 'dart:convert';
import 'dart:developer';

import 'package:bidan_care/core/utils/app_constants.dart';
import 'package:bidan_care/core/utils/auth_helper.dart';
import 'package:bidan_care/features/models/statistik.dart';
import 'package:bidan_care/shared/models/profil_bidan_body.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfilBidanViewModel extends ChangeNotifier {
  String get _endpoint => "${AppConstants.baseUrl}/api/bidan";

  Future<Statistik> getStatistics() async {
    final response = await http.get(
      Uri.parse("$_endpoint/statistik"),
      headers: {"Authorization": "Bearer ${AuthHelper.token}"},
    );
    log("Get statistik: ${response.body}");
    if (response.statusCode != 200) throw Exception("API Error");
    final data = jsonDecode(response.body)["data"];
    return Statistik.fromJson(data);
  }

  Future<bool?> updateKesediaan(bool value) async {
    try {
      final response = await http.put(
        Uri.parse("$_endpoint/kesediaan/$value"),
        headers: {"Authorization": "Bearer ${AuthHelper.token}"},
      );
      log("Update kesediaan: ${response.body}");
      if (response.statusCode == 200) {
        return jsonDecode(response.body)["data"]["bersedia"];
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<String?> updateProfil(ProfilBidanBody profilBidan) async {
    try {
      final response = await http.put(
        Uri.parse("$_endpoint/profile"),
        headers: {
          "Authorization": "Bearer ${AuthHelper.token}",
          "Content-Type": "application/json",
        },
        body: profilBidan.toJson(),
      );
      log("Update profil bidan: ${response.body}");
      if (response.statusCode != 200) {
        final message = jsonDecode(response.body)["message"];
        return message;
      }
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
    return null;
  }

  Future updateOrderStatus(String id, String status) async {
    try {
      final url = "${AppConstants.baseUrl}/api/order/update_status/$id";
      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${AuthHelper.token}",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"status": status}),
      );
      log("Update order status: ${response.body}");
    } catch (e) {
      log(e.toString());
    }
  }
}
