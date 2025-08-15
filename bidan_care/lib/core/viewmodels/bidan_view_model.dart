import 'dart:convert';
import 'dart:developer';

import 'package:bidan_care/core/models/bidan.dart';
import 'package:bidan_care/core/utils/app_constants.dart';
import 'package:bidan_care/core/utils/auth_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BidanViewModel extends ChangeNotifier {
  String get _endpoint => "${AppConstants.baseUrl}/api/bidan";

  List<Bidan> _listBidan = [];

  List<Bidan> get listBidan => _listBidan;

  Future<List<Bidan>> getBidan() async {
    final response = await http.get(
      Uri.parse(_endpoint),
      headers: {"Authorization": "Bearer ${AuthHelper.token}"},
    );
    log("Get bidan:\n${response.body}");
    if (response.statusCode != 200) throw Exception("API Error");
    final data = jsonDecode(response.body)["data"] as List;
    _listBidan = data.map((e) => Bidan.fromJson(e)).toList();
    notifyListeners();
    return _listBidan;
  }

  Future<List<Bidan>> searchBidan(String search) async {
    final response = await http.get(
      Uri.parse("$_endpoint/search/$search"),
      headers: {"Authorization": "Bearer ${AuthHelper.token}"},
    );
    log("Search bidan:\n${response.body}");
    if (response.statusCode != 200) throw Exception("API Error");
    final data = jsonDecode(response.body)["data"] as List;
    return data.map((e) => Bidan.fromJson(e)).toList();
  }

  Future<List<Bidan>> getFavoriteBidan() async {
    final response = await http.get(
      Uri.parse("$_endpoint/favorite"),
      headers: {"Authorization": "Bearer ${AuthHelper.token}"},
    );
    log("Get favorite bidan: ${response.body}");
    if (response.statusCode != 200) throw Exception("API Error");
    final data = jsonDecode(response.body)["data"] as List;
    return data.map((e) => Bidan.fromJson(e)).toList();
  }
}
