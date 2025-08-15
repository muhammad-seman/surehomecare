import 'dart:convert';

class ProfilBidanBody {
  final String nama;
  final String keterangan;
  final String idKecamatan;

  const ProfilBidanBody({
    required this.nama,
    required this.keterangan,
    required this.idKecamatan,
  });

  String toJson() {
    return jsonEncode({
      "nama": nama,
      "keterangan": keterangan,
      "idKecamatan": idKecamatan,
    });
  }
}
