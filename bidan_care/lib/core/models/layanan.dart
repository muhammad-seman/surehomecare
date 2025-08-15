import 'package:bidan_care/shared/utils/app_helpers.dart';

class Layanan {
  final String id;
  final String nama;
  final int harga;
  final String? idKategori;
  final String gambar;
  final String keterangan;

  const Layanan({
    required this.id,
    required this.nama,
    required this.harga,
    required this.gambar,
    required this.keterangan,
    this.idKategori,
  });

  factory Layanan.fromJson(Map<String, dynamic> json) {
    final gambarJson = json["gambar"];
    final gambar = AppHelpers.getImagePath(gambarJson)!;

    return Layanan(
      id: json["id"],
      nama: json["nama"],
      harga: json["harga"],
      idKategori: json["idKategori"],
      gambar: gambar,
      keterangan: json["keterangan"],
    );
  }
}

const String _contohGambar =
    "https://www.shutterstock.com/image-vector/hijab-vector-woman-female-logo-260nw-396753151.jpg";

const List<Layanan> dummyLayanan = [
  Layanan(
    id: "1",
    nama: "Contoh Layanan",
    harga: 50000,
    gambar: _contohGambar,
    keterangan:
        "Lorem ipsum dolor sit amet consectetur adipisicing elit. Laboriosam deserunt molestias dolorem aperiam doloribus rem vel!",
  ),
  Layanan(
    id: "2",
    nama: "Contoh Layanan",
    harga: 50000,
    gambar: _contohGambar,
    keterangan:
        "Lorem ipsum dolor sit amet consectetur adipisicing elit. Laboriosam deserunt molestias dolorem aperiam doloribus rem vel!",
  ),
  Layanan(
    id: "3",
    nama: "Contoh Layanan",
    harga: 50000,
    gambar: _contohGambar,
    keterangan:
        "Lorem ipsum dolor sit amet consectetur adipisicing elit. Laboriosam deserunt molestias dolorem aperiam doloribus rem vel!",
  ),
  Layanan(
    id: "4",
    nama: "Contoh Layanan",
    harga: 50000,
    gambar: _contohGambar,
    keterangan:
        "Lorem ipsum dolor sit amet consectetur adipisicing elit. Laboriosam deserunt molestias dolorem aperiam doloribus rem vel!",
  ),
  Layanan(
    id: "5",
    nama: "Contoh Layanan",
    harga: 50000,
    gambar: _contohGambar,
    keterangan:
        "Lorem ipsum dolor sit amet consectetur adipisicing elit. Laboriosam deserunt molestias dolorem aperiam doloribus rem vel!",
  ),
  Layanan(
    id: "6",
    nama: "Contoh Layanan",
    harga: 50000,
    gambar: _contohGambar,
    keterangan:
        "Lorem ipsum dolor sit amet consectetur adipisicing elit. Laboriosam deserunt molestias dolorem aperiam doloribus rem vel!",
  ),
  Layanan(
    id: "7",
    nama: "Contoh Layanan",
    harga: 50000,
    gambar: _contohGambar,
    keterangan:
        "Lorem ipsum dolor sit amet consectetur adipisicing elit. Laboriosam deserunt molestias dolorem aperiam doloribus rem vel!",
  ),
  Layanan(
    id: "8",
    nama: "Contoh Layanan",
    harga: 50000,
    gambar: _contohGambar,
    keterangan:
        "Lorem ipsum dolor sit amet consectetur adipisicing elit. Laboriosam deserunt molestias dolorem aperiam doloribus rem vel!",
  ),
];
