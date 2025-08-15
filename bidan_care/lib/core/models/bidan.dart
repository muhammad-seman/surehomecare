import 'package:bidan_care/core/models/layanan.dart';
import 'package:bidan_care/shared/utils/app_helpers.dart';

class Bidan {
  final String id;
  final String nama;
  final String? thumbnail;
  final String keterangan;
  final int jlhLayanan;
  final String idDetails;
  final BidanDetails? details;
  final bool bersedia;

  const Bidan({
    required this.id,
    required this.nama,
    required this.thumbnail,
    required this.keterangan,
    required this.jlhLayanan,
    required this.idDetails,
    this.details,
    required this.bersedia,
  });

  factory Bidan.fromJson(Map<String, dynamic> json) {
    final gambar = AppHelpers.getImagePath(json["gambar"]);

    return Bidan(
      id: json["id"],
      nama: json["nama"],
      thumbnail: gambar,
      keterangan: json["keterangan"],
      jlhLayanan: json["jlhLayanan"],
      idDetails: json["idDetails"],
      bersedia: json["bersedia"],
    );
  }
}

class BidanDetails {
  final bool isFavorite;
  final List<Layanan> listLayanan;

  const BidanDetails({
    required this.isFavorite,
    required this.listLayanan,
  });
}

const String _contohGambar =
    "https://www.shutterstock.com/image-vector/hijab-vector-woman-female-logo-260nw-396753151.jpg";
const String _contohKeterangan =
    "Lorem ipsum dolor sit amet consectetur adipisicing elit. Enim, amet quaerat minima cumque vero dignissimos ipsum ex voluptates aliquam provident fugit earum repudiandae, suscipit totam ut nemo ab cum, veritatis facilis non.";

const List<Bidan> dummyBidan = [
  Bidan(
    id: "1",
    nama: "Contoh Bidan",
    thumbnail: _contohGambar,
    keterangan: _contohKeterangan,
    jlhLayanan: 5,
    details: BidanDetails(
      isFavorite: true,
      listLayanan: dummyLayanan,
    ),
    idDetails: "1",
    bersedia: true,
  ),
  Bidan(
    id: "2",
    nama: "Contoh Bidan",
    thumbnail: _contohGambar,
    keterangan: _contohKeterangan,
    jlhLayanan: 5,
    details: BidanDetails(
      isFavorite: false,
      listLayanan: dummyLayanan,
    ),
    idDetails: "2",
    bersedia: true,
  ),
  Bidan(
    id: "3",
    nama: "Contoh Bidan",
    thumbnail: _contohGambar,
    keterangan: _contohKeterangan,
    jlhLayanan: 5,
    details: BidanDetails(
      isFavorite: false,
      listLayanan: dummyLayanan,
    ),
    idDetails: "3",
    bersedia: true,
  ),
  Bidan(
    id: "4",
    nama: "Contoh Bidan",
    thumbnail: _contohGambar,
    keterangan: _contohKeterangan,
    jlhLayanan: 5,
    details: BidanDetails(
      isFavorite: false,
      listLayanan: dummyLayanan,
    ),
    idDetails: "4",
    bersedia: true,
  ),
];
