import 'dart:convert';

import 'package:bidan_care/features/messages/models/abstract_message.dart';

class SendMessage extends AbstractMessage {
  final String penerima;
  bool isFailed = false;

  SendMessage({
    required super.isi,
    required this.penerima,
  });

  String toJson() {
    return jsonEncode({
      "penerima": penerima,
      "isi": isi,
    });
  }
}
