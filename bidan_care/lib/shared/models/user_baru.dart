import 'dart:convert';

class UserBaru {
  final String nama;
  final String email;
  final String noHp;
  final String password;
  final String idKecamatan;
  final double latitude;
  final double longitude;
  final String alamat;

  const UserBaru({
    required this.nama,
    required this.email,
    required this.noHp,
    required this.password,
    required this.idKecamatan,
    required this.latitude,
    required this.longitude,
    required this.alamat,
  });

  String toJson() {
    return jsonEncode({
      "nama": nama,
      "email": email,
      "noHp": noHp,
      "password": password,
      "idKecamatan": idKecamatan,
      "latitude": latitude,
      "longitude": longitude,
      "alamat": alamat,
    });
  }
}
