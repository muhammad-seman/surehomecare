import 'package:bidan_care/shared/utils/app_helpers.dart';

class OpposeUser {
  final String id;
  final String nama;
  final String? gambar;

  const OpposeUser({
    required this.id,
    required this.nama,
    required this.gambar,
  });

  factory OpposeUser.fromJson(Map<String, dynamic> json) {
    final gambarJson = json["gambar"];
    final gambar =
        gambarJson == null ? null : AppHelpers.getImagePath(gambarJson);

    return OpposeUser(
      id: json["id"],
      nama: json["nama"],
      gambar: gambar,
    );
  }
}
