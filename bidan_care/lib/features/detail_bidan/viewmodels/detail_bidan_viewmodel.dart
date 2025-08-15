import 'dart:convert';
import 'dart:developer';

import 'package:bidan_care/core/models/bidan.dart';
import 'package:bidan_care/core/models/layanan.dart';
import 'package:bidan_care/core/utils/app_constants.dart';
import 'package:bidan_care/core/utils/auth_helper.dart';
import 'package:bidan_care/features/detail_bidan/models/order.dart';
import 'package:bidan_care/features/detail_bidan/models/order_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailBidanViewmodel extends ChangeNotifier {
  final Bidan bidan;
  DetailBidanViewmodel(this.bidan);

  String get _endpoint => "${AppConstants.baseUrl}/api";

  bool _isFavorite = false;
  final List<Layanan> _selectedLayanan = [];

  bool get isFavorite => _isFavorite;
  List<Layanan> get selectedLayanan => _selectedLayanan;

  Future<List<Layanan>> getBidanDetails() async {
    final response = await http.get(
      Uri.parse("$_endpoint/bidan/details/${bidan.idDetails}"),
      headers: {"Authorization": "Bearer ${AuthHelper.token}"},
    );
    log("Get bidan details:\n${response.body}");
    if (response.statusCode != 200) throw Exception("API Error");
    final data = jsonDecode(response.body)["data"];
    _isFavorite = data["isFavorite"];
    notifyListeners();
    final listLayananJson = data["listLayanan"] as List;
    final listLayanan =
        listLayananJson.map((e) => Layanan.fromJson(e)).toList();
    return listLayanan;
  }

  Future<OrderResponse> createOrder() async {
    final order = Order(
      idBidan: bidan.id,
      detailOrder: selectedLayanan.map((layanan) {
        return DetailOrder(
          idLayanan: layanan.id,
          namaLayanan: layanan.nama,
          jlhBayar: layanan.harga,
          gambar: layanan.gambar,
        );
      }).toList(),
    );

    OrderResponse orderResponse = OrderResponse();

    try {
      final response = await http.post(
        Uri.parse("$_endpoint/order/pesan"),
        headers: {
          "Authorization": "Bearer ${AuthHelper.token}",
          "Content-Type": "application/json",
        },
        body: order.toJson(),
      );
      log("Get create order:\n${response.body}");
      if (response.statusCode != 201) {
        final message = jsonDecode(response.body)["message"];
        orderResponse.error = message;
      }
      final ongoing = jsonDecode(response.body)["data"]["ongoing"];
      orderResponse.fetchBidan = ongoing == "bidan";
    } catch (e) {
      log(e.toString());
      orderResponse.error = "Terjadi kesalahan";
    }
    return orderResponse;
  }

  void toggleItem(Layanan layanan) {
    _selectedLayanan.contains(layanan)
        ? _selectedLayanan.remove(layanan)
        : _selectedLayanan.add(layanan);

    notifyListeners();
  }

  Future<bool> setFavoriteBidan(bool status) async {
    try {
      final response = await http.put(
        Uri.parse("$_endpoint/bidan/favorite/${bidan.idDetails}"),
        headers: {
          "Authorization": "Bearer ${AuthHelper.token}",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"status": status}),
      );
      log("Set favorite bidan: ${response.body}");
      if (response.statusCode == 200) {
        _isFavorite = status;
        notifyListeners();
        return true;
      }
    } catch (e) {
      log(e.toString());
    }
    return false;
  }
}
