import 'package:bidan_care/shared/utils/app_helpers.dart';

class BidanOrder {
  final String id;
  final String nama;
  final String? gambar;
  final double latitude;
  final double longitude;
  final String alamat;
  final List<String> namaLayanan;

  const BidanOrder({
    required this.id,
    required this.nama,
    required this.gambar,
    required this.latitude,
    required this.longitude,
    required this.alamat,
    required this.namaLayanan,
  });

  factory BidanOrder.fromJson(Map<String, dynamic> json) {
    final gambar = AppHelpers.getImagePath(json["gambar"]);
    final namaLayananJson = json["detailOrder"] as List;
    final namaLayanan = namaLayananJson.map((e) => e.toString()).toList();

    return BidanOrder(
      id: json["id"],
      nama: json["nama"],
      gambar: gambar,
      latitude: json["latitude"],
      longitude: json["longitude"],
      alamat: json["alamat"],
      namaLayanan: namaLayanan,
    );
  }
}
