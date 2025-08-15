import 'package:flutter/material.dart';
import 'package:location/location.dart';

class DaftarViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final hpController = TextEditingController();
  final passwordController = TextEditingController();
  final kPasswordController = TextEditingController();
  final latController = TextEditingController();
  final longController = TextEditingController();
  final alamatController = TextEditingController();

  String? idKecamatan;
  String? idProvinsi;
  String _modeLokasi = "auto";

  double? _lat;
  double? _long;

  double get lat {
    if (_lat != null) return _lat!;
    final newLat = double.tryParse(latController.text);
    if (newLat == null) throw KoordinatException("Latitude tidak valid");
    return newLat;
  }

  double get long {
    if (_long != null) return _long!;
    final newLong = double.tryParse(longController.text);
    if (newLong == null) throw KoordinatException("Longitude tidak valid");
    return newLong;
  }

  String get modeLokasi => _modeLokasi;

  set modeLokasi(String modeBaru) {
    _modeLokasi = modeBaru;
    if (modeBaru == "custom") {
      _lat = null;
      _long = null;
    }
  }

  Future<bool> getLokasiUser() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    // Perizinan
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    // Update lokasi
    locationData = await location.getLocation();
    _lat = locationData.latitude!;
    _long = locationData.longitude!;
    return true;
  }
}

class KoordinatException implements Exception {
  final String message;
  KoordinatException(this.message);

  @override
  String toString() {
    return message;
  }
}
