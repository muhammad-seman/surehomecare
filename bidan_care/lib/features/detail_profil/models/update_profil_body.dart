import 'dart:convert';

class UpdateProfilBody {
  final String nama;
  final String email;
  final String noHp;
  final String idKecamatan;
  final String alamat;

  const UpdateProfilBody({
    required this.nama,
    required this.email,
    required this.noHp,
    required this.idKecamatan,
    required this.alamat,
  });

  String toJson() {
    return jsonEncode({
      "nama": nama,
      "email": email,
      "noHp": noHp,
      "idKecamatan": idKecamatan,
      "alamat": alamat,
    });
  }
}
