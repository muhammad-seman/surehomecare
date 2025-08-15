import 'dart:convert';
import 'dart:developer';

import 'package:bidan_care/core/models/profil_bidan.dart';
import 'package:bidan_care/core/models/ubah_password_request.dart';
import 'package:bidan_care/core/models/user.dart';
import 'package:bidan_care/core/utils/app_constants.dart';
import 'package:bidan_care/core/utils/auth_helper.dart';
import 'package:bidan_care/shared/models/user_baru.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends ChangeNotifier {
  String get _endpoint => "${AppConstants.baseUrl}/api";

  User? _currentUser;
  ProfilBidan? _profilBidan;
  String? _token;
  bool _isNewUser = true;
  UbahPasswordRequest? _ubahPasswordRequest;

  User? get currentUser => _currentUser;
  String? get token => _token;
  bool get isNewUser => _isNewUser;
  ProfilBidan? get profilBidan => _profilBidan;
  set token(String? newToken) => _setToken(newToken);

  Future<bool?> getProfile({bool notify = true}) async {
    try {
      final response = await http.get(
        Uri.parse("$_endpoint/profile"),
        headers: {
          "Authorization": "Bearer $_token",
        },
      );
      log("Get profil:\n${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["data"];
        _currentUser = User.fromJson(data);

        if (_currentUser!.isBidan) {
          final bidanJson = jsonDecode(response.body)["bidan"];
          _profilBidan = ProfilBidan.fromJson(bidanJson);
        }
        if (notify) notifyListeners();
      }
      if (response.statusCode == 401) {
        logout();
      }
      return true;
    } catch (e) {
      log(e.toString());
    }

    if (notify) notifyListeners();
    return false;
  }

  Future<String?> daftar(UserBaru user) async {
    String? error;
    try {
      final response = await http.post(
        Uri.parse("$_endpoint/register"),
        headers: {
          "Content-Type": "application/json",
        },
        body: user.toJson(),
      );
      log("Register user:\n${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["data"];
        _currentUser = User.fromJson(data);
        updateNewUser();
        token = data["token"];
      } else {
        error = jsonDecode(response.body)["message"];
      }
    } catch (e) {
      log(e.toString());
      error = "Terjadi kesalahan, silahkan coba lagi";
    }

    notifyListeners();
    return error;
  }

  Future<String?> login(String email, String password) async {
    String? error;

    try {
      final response = await http.post(
        Uri.parse("$_endpoint/login"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );
      log("Login user:\n${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["data"];
        _currentUser = User.fromJson(data);
        token = data["token"];
        if (_currentUser!.isBidan) {
          final bidanJson = jsonDecode(response.body)["bidan"];
          _profilBidan = ProfilBidan.fromJson(bidanJson);
        }
      } else {
        error = jsonDecode(response.body)["message"];
      }
    } catch (e) {
      log(e.toString());
      error = "Terjadi kesalahan, silahkan coba lagi";
    }

    notifyListeners();
    return error;
  }

  Future<bool> logout() async {
    try {
      final response = await http.get(
        Uri.parse("$_endpoint/logout"),
        headers: {"Authorization": "Bearer $_token"},
      );
      log("Logout user:\n${response.body}");
      token = null;
      _currentUser = null;
      _profilBidan = null;
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      log(e.toString());
    }
    token = null;
    _currentUser = null;
    return false;
  }

  Future<String> requestUbahPassword(String email) async {
    String error = "";

    try {
      final response = await http.post(
        Uri.parse("$_endpoint/request_ubah_password"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({"email": email}),
      );
      log("Request ubah password:\n${response.body}");
      if (response.statusCode == 200) {
        _ubahPasswordRequest = UbahPasswordRequest(email: email);
      } else {
        error = jsonDecode(response.body)["message"];
      }
    } catch (e) {
      log(e.toString());
      error = "Terjadi kesalahan, silahkan coba lagi";
    }
    return error;
  }

  Future<String> checkOTP(int kodeOTP) async {
    String error = "";

    try {
      _ubahPasswordRequest!.kodeOTP = kodeOTP;
      final response = await http.post(
        Uri.parse("$_endpoint/check_otp"),
        headers: {
          "Content-Type": "application/json",
        },
        body: _ubahPasswordRequest!.toJson(),
      );
      log("Check otp:\n${response.body}");
      if (response.statusCode != 200) {
        error = jsonDecode(response.body)["message"];
      }
    } catch (e) {
      log(e.toString());
      error = "Terjadi kesalahan, silahkan coba lagi";
    }
    return error;
  }

  Future<String> ubahPasswordOTP(String password) async {
    String error = "";

    try {
      _ubahPasswordRequest!.password = password;
      final response = await http.post(
        Uri.parse("$_endpoint/ubah_password_otp"),
        headers: {
          "Content-Type": "application/json",
        },
        body: _ubahPasswordRequest!.toJson(),
      );
      log("Ubah password otp:\n${response.body}");
      if (response.statusCode != 200) {
        error = jsonDecode(response.body)["message"];
      }
    } catch (e) {
      log(e.toString());
      error = "Terjadi kesalahan, silahkan coba lagi";
    }

    return error;
  }

  Future authCheck() async {
    final prefs = await SharedPreferences.getInstance();
    _isNewUser = prefs.getBool("NEW_USER") ?? true;
    final token = prefs.getString("TOKEN");
    if (token == null) {
      log("Token: NO TOKEN");
      return;
    }
    log("Token: $token");
    AuthHelper.token = token;
    _token = token;
    await getProfile();
  }

  void updateNewUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("NEW_USER", false);
    _isNewUser = false;
    notifyListeners();
  }

  void _setToken(String? token) async {
    AuthHelper.token = token;
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    if (token == null) {
      prefs.remove("TOKEN");
    } else {
      prefs.setString("TOKEN", token);
    }

    notifyListeners();
  }
}
