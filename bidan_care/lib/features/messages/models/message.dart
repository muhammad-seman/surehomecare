import 'package:bidan_care/features/messages/models/abstract_message.dart';

class Message extends AbstractMessage {
  final String id;
  final DateTime createdAt;
  final DateTime? tglTerkirim;

  const Message({
    required this.id,
    required super.isPengirim,
    required super.isi,
    required this.createdAt,
    required this.tglTerkirim,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    final tglTerkirimJson = json["tglTerkirim"];

    return Message(
      id: json["id"],
      isPengirim: json["isPengirim"],
      isi: json["isi"],
      createdAt: DateTime.parse(json["createdAt"]),
      tglTerkirim:
          tglTerkirimJson != null ? DateTime.parse(tglTerkirimJson) : null,
    );
  }
}
