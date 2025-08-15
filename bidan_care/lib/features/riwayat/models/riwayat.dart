import 'package:bidan_care/features/riwayat/models/riwayat_bidan.dart';
import 'package:bidan_care/shared/models/riwayat_layanan.dart';

class Riwayat {
  final String id;
  final RiwayatBidan? bidan;
  final List<RiwayatLayanan> listLayanan;
  final String status;
  final DateTime? tglSelesai;

  Riwayat({
    required this.id,
    required this.bidan,
    required this.listLayanan,
    required this.status,
    this.tglSelesai,
  });

  String get statusMessage {
    final messages = {
      "diajukan": "Diajukan",
      "ongoing": "Ongoing",
      "ditolak": "Ditolak",
      "dibatal": "Dibatalkan",
      "selesai": ""
    };
    return messages[status] ?? "-";
  }

  factory Riwayat.fromJson(Map<String, dynamic> json) {
    final listLayananJson = json["detailOrder"] as List;
    final bidanJson = json["bidan"];
    final tglSelesaiJson = json["tglSelesai"];
    final tglSelesai =
        tglSelesaiJson != null ? DateTime.parse(tglSelesaiJson) : null;

    return Riwayat(
      id: json["id"],
      bidan: RiwayatBidan.fromJson(bidanJson),
      listLayanan:
          listLayananJson.map((e) => RiwayatLayanan.fromJson(e)).toList(),
      status: json["status"],
      tglSelesai: tglSelesai,
    );
  }
}

const List<RiwayatLayanan> _dummyRiwyatLayanan = [
  RiwayatLayanan(
    nama: "Contoh Layanan 1",
    jlhBayar: 50000,
  ),
  RiwayatLayanan(
    nama: "Contoh Layanan 2",
    jlhBayar: 50000,
  ),
  RiwayatLayanan(
    nama: "Contoh Layanan 3",
    jlhBayar: 50000,
  ),
  RiwayatLayanan(
    nama: "Contoh Layanan 4",
    jlhBayar: 50000,
  ),
];
final List<Riwayat> dummyRiwayat = [
  Riwayat(
    id: "1",
    bidan: dummyRiwayatBidan,
    listLayanan: _dummyRiwyatLayanan,
    status: "ongoing",
  ),
  Riwayat(
    id: "2",
    bidan: dummyRiwayatBidan,
    listLayanan: _dummyRiwyatLayanan,
    status: "diajukan",
    tglSelesai: DateTime(2024, 10, 2, 20, 19),
  ),
  Riwayat(
    id: "3",
    bidan: dummyRiwayatBidan,
    listLayanan: _dummyRiwyatLayanan,
    status: "ditolak",
    tglSelesai: DateTime(2024, 10, 2, 20, 19),
  ),
  Riwayat(
    id: "4",
    bidan: dummyRiwayatBidan,
    listLayanan: _dummyRiwyatLayanan,
    status: "dibatal",
    tglSelesai: DateTime(2024, 10, 2, 20, 19),
  ),
  Riwayat(
    id: "5",
    bidan: dummyRiwayatBidan,
    listLayanan: _dummyRiwyatLayanan,
    status: "selesai",
    tglSelesai: DateTime(2024, 10, 2, 20, 19),
  ),
];
