import 'dart:convert';
import 'dart:developer';

import 'package:bidan_care/core/models/bidan.dart';
import 'package:bidan_care/core/utils/app_constants.dart';
import 'package:bidan_care/core/utils/auth_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RecentBidanViewModel extends ChangeNotifier {
  String get _endpoint => "${AppConstants.baseUrl}/api/bidan/recent";

  List<Bidan> _recentBidan = [];

  List<Bidan> get recentBidan => _recentBidan;

  Future<List<Bidan>> getRecentBidan() async {
    final response = await http.get(
      Uri.parse(_endpoint),
      headers: {"Authorization": "Bearer ${AuthHelper.token}"},
    );
    log("Get recent bidan:\n${response.body}");
    if (response.statusCode != 200) throw Exception("API Error");
    final data = jsonDecode(response.body)["data"] as List;
    _recentBidan = data.map((e) => Bidan.fromJson(e)).toList();
    notifyListeners();
    return _recentBidan;
  }
}
