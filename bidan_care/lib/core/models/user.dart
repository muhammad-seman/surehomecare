import 'package:bidan_care/shared/models/daerah.dart';
import 'package:bidan_care/shared/utils/app_helpers.dart';

class User {
  final String id;
  final String nama;
  final String email;
  final String noHp;
  final Daerah kecamatan;
  final Daerah provinsi;
  final String? gambar;
  final double? latitude;
  final double? longitude;
  final bool isBidan;
  final String alamat;

  const User({
    required this.id,
    required this.nama,
    required this.email,
    required this.noHp,
    required this.kecamatan,
    required this.provinsi,
    required this.gambar,
    required this.latitude,
    required this.longitude,
    required this.isBidan,
    required this.alamat,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final gambarJson = json["gambar"];
    final gambar =
        gambarJson != null ? AppHelpers.getImagePath(gambarJson) : null;

    return User(
      id: json["id"],
      nama: json["nama"],
      email: json["email"],
      noHp: json["noHp"],
      kecamatan: Daerah.fromJson(json["kecamatan"]),
      provinsi: Daerah.fromJson(json["kecamatan"]["provinsi"]),
      gambar: gambar,
      latitude: json["latitude"],
      longitude: json["longitude"],
      isBidan: json["isBidan"],
      alamat: json["alamat"],
    );
  }
}

final User dummyUser = User(
  id: "1",
  nama: "User 1",
  email: "zuzuzu@gmail.com",
  noHp: "08181818",
  latitude: 5.201338008891665,
  longitude: 97.06376212648499,
  kecamatan: Daerah(id: "235", nama: "Lhokeumawe"),
  provinsi: Daerah(id: "123", nama: "Aceh"),
  gambar:
      "https://www.shutterstock.com/image-vector/hijab-vector-woman-female-logo-260nw-396753151.jpg",
  isBidan: false,
  alamat: "Bukit Indah",
);
