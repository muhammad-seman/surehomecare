import 'dart:convert';

class UbahPasswordRequest {
  final String email;
  int? kodeOTP;
  String? password;

  UbahPasswordRequest({
    required this.email,
    this.kodeOTP,
    this.password,
  });

  String toJson() {
    return jsonEncode({
      "email": email,
      "kodeOTP": kodeOTP,
      "password": password,
    });
  }
}
