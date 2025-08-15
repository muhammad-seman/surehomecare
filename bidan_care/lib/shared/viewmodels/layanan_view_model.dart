import 'dart:convert';
import 'dart:developer';

import 'package:bidan_care/core/utils/app_constants.dart';
import 'package:bidan_care/core/utils/auth_helper.dart';
import 'package:bidan_care/features/home/models/top_layanan.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LayananViewModel extends ChangeNotifier {
  String get _endpoint => "${AppConstants.baseUrl}/api/layanan";

  List<TopLayanan> _topLayanan = [];

  List<TopLayanan> get topLayanan => _topLayanan;

  Future<List<TopLayanan>> getTopLayanan() async {
    final response = await http.get(
      Uri.parse(_endpoint),
      headers: {"Authorization": "Bearer ${AuthHelper.token}"},
    );
    log("Get top layanan:\n${response.body}");
    if (response.statusCode != 200) throw Exception("API Error");
    final data = jsonDecode(response.body)["data"] as List;
    _topLayanan = data.map((e) => TopLayanan.fromJson(e)).toList();
    notifyListeners();
    return _topLayanan;
  }
}
