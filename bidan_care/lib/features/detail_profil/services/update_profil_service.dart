import 'dart:convert';
import 'dart:developer';

import 'package:bidan_care/core/utils/app_constants.dart';
import 'package:bidan_care/core/utils/auth_helper.dart';
import 'package:bidan_care/features/detail_profil/models/update_profil_body.dart';
import 'package:http/http.dart' as http;

class UpdateProfilService {
  String get _endpoint => "${AppConstants.baseUrl}/api/profile";

  Future<String?> updateProfil(UpdateProfilBody profilBody) async {
    try {
      final response = await http.put(
        Uri.parse(_endpoint),
        headers: {
          "Authorization": "Bearer ${AuthHelper.token}",
          "Content-Type": "application/json",
        },
        body: profilBody.toJson(),
      );
      log("Update profil: ${response.body}");
      if (response.statusCode != 200) {
        final message = jsonDecode(response.body)["message"];
        return message;
      }
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
    return null;
  }
}
