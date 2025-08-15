import 'dart:convert';
import 'dart:io';

class LayananBaru {
  final String nama;
  final int harga;
  final String idKategori;
  final File? gambar;
  final String keterangan;

  const LayananBaru({
    required this.nama,
    required this.harga,
    required this.idKategori,
    required this.gambar,
    required this.keterangan,
  });

  String toJson() {
    return jsonEncode({
      "nama": nama,
      "harga": harga,
      "idKategori": idKategori,
      "keterangan": keterangan,
    });
  }
}
