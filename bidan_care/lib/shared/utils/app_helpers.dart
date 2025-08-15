import 'package:bidan_care/core/utils/app_constants.dart';
import 'package:bidan_care/features/messages/models/oppose_user.dart';
import 'package:bidan_care/features/messages/viewmodels/message_view_model.dart';
import 'package:bidan_care/routes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AppHelpers {
  static String formatHarga(int harga) {
    return NumberFormat("Rp ###,###,###").format(harga);
  }

  static String formatTanggal(DateTime tanggal) {
    return DateFormat("dd/MM/yyyy").format(tanggal);
  }

  static String? getImagePath(String? fileName) {
    if (fileName == null) return null;
    return "${AppConstants.baseUrl}/images/$fileName";
  }

  static onLogout(BuildContext context) {
    context.read<MessageViewModel>().onLogout();
  }

  static onInit(BuildContext context) {
    context.read<MessageViewModel>().onInit();
  }

  static pushChatroom(BuildContext context, OpposeUser oppose) {
    Navigator.pushNamed(
      context,
      Routes.chatroom,
      arguments: oppose,
    ).then((_) => context.read<MessageViewModel>().onLeaveRoom());
  }

  static redirectGoogleMaps(double lat, double long) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      Fluttertoast.showToast(
        msg: "Tidak dapat membuka Google Maps",
        backgroundColor: Colors.black87,
        textColor: Colors.white,
      );
    }
  }
}
