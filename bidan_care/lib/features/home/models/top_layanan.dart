import 'package:bidan_care/shared/utils/app_helpers.dart';

class TopLayanan {
  final String id;
  final String nama;
  final String gambar;

  const TopLayanan({
    required this.id,
    required this.nama,
    required this.gambar,
  });

  factory TopLayanan.fromJson(Map<String, dynamic> json) {
    final gambar = AppHelpers.getImagePath(json["gambar"])!;

    return TopLayanan(
      id: json["id"],
      nama: json["nama"],
      gambar: gambar,
    );
  }
}

const String _contohGambar =
    "https://www.shutterstock.com/image-vector/hijab-vector-woman-female-logo-260nw-396753151.jpg";
const List<TopLayanan> dummyTopLayanan = [
  TopLayanan(
    id: "1",
    nama: "Contoh Layanan",
    gambar: _contohGambar,
  ),
  TopLayanan(
    id: "2",
    nama: "Contoh Layanan",
    gambar: _contohGambar,
  ),
  TopLayanan(
    id: "3",
    nama: "Contoh Layanan",
    gambar: _contohGambar,
  ),
  TopLayanan(
    id: "4",
    nama: "Contoh Layanan",
    gambar: _contohGambar,
  ),
  TopLayanan(
    id: "5",
    nama: "Contoh Layanan",
    gambar: _contohGambar,
  ),
  TopLayanan(
    id: "6",
    nama: "Contoh Layanan",
    gambar: _contohGambar,
  ),
  TopLayanan(
    id: "7",
    nama: "Contoh Layanan",
    gambar: _contohGambar,
  ),
  TopLayanan(
    id: "8",
    nama: "Contoh Layanan",
    gambar: _contohGambar,
  ),
];
