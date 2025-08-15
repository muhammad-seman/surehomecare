import 'package:bidan_care/shared/utils/app_helpers.dart';

class RiwayatBidan {
  final String nama;
  final String? thumbnail;

  const RiwayatBidan({
    required this.nama,
    required this.thumbnail,
  });

  factory RiwayatBidan.fromJson(Map<String, dynamic> json) {
    final thumbnail = AppHelpers.getImagePath(json["thumbnail"]);

    return RiwayatBidan(
      nama: json["nama"],
      thumbnail: thumbnail,
    );
  }
}

const String _contohGambar =
    "https://www.shutterstock.com/image-vector/hijab-vector-woman-female-logo-260nw-396753151.jpg";
const dummyRiwayatBidan = RiwayatBidan(
  nama: "Contoh Bidan",
  thumbnail: _contohGambar,
);
