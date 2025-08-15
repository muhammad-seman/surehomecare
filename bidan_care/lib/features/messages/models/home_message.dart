import 'package:bidan_care/features/messages/models/oppose_user.dart';

class HomeMessage {
  final String id;
  final OpposeUser oppose;
  final String isi;
  final bool isPengirim;
  final DateTime createdAt;
  final DateTime? tglBaca;

  const HomeMessage({
    required this.id,
    required this.oppose,
    required this.isi,
    required this.isPengirim,
    required this.createdAt,
    required this.tglBaca,
  });

  factory HomeMessage.fromJson(Map<String, dynamic> json) {
    final tglBacaJson = json["tglBaca"];
    final tglBaca =
        tglBacaJson != null ? DateTime.parse(json["tglBaca"]) : null;

    return HomeMessage(
      id: json["id"],
      oppose: OpposeUser.fromJson(json["oppose"]),
      isi: json["isi"],
      isPengirim: json["isPengirim"],
      createdAt: DateTime.parse(json["createdAt"]),
      tglBaca: tglBaca,
    );
  }
}
