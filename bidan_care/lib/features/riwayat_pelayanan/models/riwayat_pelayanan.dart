import 'package:bidan_care/features/riwayat_pelayanan/models/pelayanan_user.dart';
import 'package:bidan_care/shared/models/riwayat_layanan.dart';

class RiwayatPelayanan {
  final String id;
  final List<RiwayatLayanan> listLayanan;
  final String status;
  final DateTime? tglSelesai;
  final PelayananUser user;

  const RiwayatPelayanan({
    required this.id,
    required this.listLayanan,
    required this.status,
    required this.tglSelesai,
    required this.user,
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

  factory RiwayatPelayanan.fromJson(Map<String, dynamic> json) {
    final listLayananJson = json["detailOrder"] as List;
    final tglSelesaiJson = json["tglSelesai"];
    final tglSelesai =
        tglSelesaiJson != null ? DateTime.parse(tglSelesaiJson) : null;

    return RiwayatPelayanan(
      id: json["id"],
      listLayanan:
          listLayananJson.map((e) => RiwayatLayanan.fromJson(e)).toList(),
      status: json["status"],
      tglSelesai: tglSelesai,
      user: PelayananUser.fromJson(json["user"]),
    );
  }
}
