import 'package:bidan_care/shared/utils/app_helpers.dart';

class RiwayatLayanan {
  final String nama;
  final int jlhBayar;
  final String? gambar;

  const RiwayatLayanan({
    required this.nama,
    required this.jlhBayar,
    this.gambar,
  });

  factory RiwayatLayanan.fromJson(Map<String, dynamic> json) {
    final gambarJson = json["layanan"]?["gambar"];
    final gambar = AppHelpers.getImagePath(gambarJson);

    return RiwayatLayanan(
      nama: json["namaLayanan"],
      jlhBayar: json["jlhBayar"],
      gambar: gambar,
    );
  }
}
