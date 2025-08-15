import 'package:bidan_care/shared/utils/app_helpers.dart';

class PelayananUser {
  final String nama;
  final String? gambar;
  final double latitude;
  final double longitude;
  final String alamat;

  const PelayananUser({
    required this.nama,
    required this.gambar,
    required this.latitude,
    required this.longitude,
    required this.alamat,
  });

  factory PelayananUser.fromJson(Map<String, dynamic> json) {
    print(json);
    final gambar = AppHelpers.getImagePath(json["gambar"]);

    return PelayananUser(
      nama: json["nama"],
      gambar: gambar,
      latitude: json["latitude"],
      longitude: json["longitude"],
      alamat: json["alamat"],
    );
  }
}
