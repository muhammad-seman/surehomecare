import 'package:bidan_care/core/layouts/auth_layout.dart';
import 'package:bidan_care/features/authentication/views/daftar_berhasil_page.dart';
import 'package:bidan_care/features/authentication/views/daftar_page.dart';
import 'package:bidan_care/features/detail_bidan/views/detail_bidan_page.dart';
import 'package:bidan_care/features/detail_bidan/views/pesan_berhasil_page.dart';
import 'package:bidan_care/features/detail_profil/views/detail_profil_page.dart';
import 'package:bidan_care/features/detail_profil/views/update_profil_page.dart';
import 'package:bidan_care/features/lupa_password/views/check_otp_page.dart';
import 'package:bidan_care/features/lupa_password/views/request_ubah_password_page.dart';
import 'package:bidan_care/features/lupa_password/views/ubah_password_otp_page.dart';
import 'package:bidan_care/features/messages/view/chatroom_page.dart';
import 'package:bidan_care/features/messages/view/messages_page.dart';
import 'package:bidan_care/features/my_layanan/views/edit_layanan_page.dart';
import 'package:bidan_care/features/my_layanan/views/my_layanan_page.dart';
import 'package:bidan_care/features/my_layanan/views/tambah_layanan_page.dart';
import 'package:bidan_care/features/order_masuk/views/order_masuk_page.dart';
import 'package:bidan_care/features/profil/views/favorit_page.dart';
import 'package:bidan_care/features/hasil_pencarian/views/hasil_pencarian_page.dart';
import 'package:bidan_care/features/home/views/semua_layanan_page.dart';
import 'package:bidan_care/features/profil/views/lokasi_tersimpan_page.dart';
import 'package:bidan_care/features/profil_bidan/views/update_profil_bidan_page.dart';
import 'package:bidan_care/features/profil_bidan/views/profil_bidan_page.dart';
import 'package:bidan_care/features/riwayat/views/detail_riwayat_page.dart';
import 'package:bidan_care/features/riwayat_pelayanan/views/detail_riwayat_pelayanan_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String main = "/";
  static const String layanan = "/layanan";
  static const String favorit = "/favorit";
  static const String lokasiTersimpan = "/lokasi_tersimpan";
  static const String hasilPencarian = "/hasil_pencarian";
  static const String detailRiwayat = "/detail_riwayat";
  static const String detailBidan = "/detail_bidan";
  static const String pesanBerhasil = "/pesan_berhasil";
  static const String daftar = "/daftar";
  static const String daftarBerhasil = "/daftar_berhasil";
  static const String messages = "/messages";
  static const String chatroom = "/chatroom";
  static const String profilBidan = "/profil_bidan";
  static const String updateProfilBidan = "/update_profil_bidan";
  static const String orderMasuk = "/order_masuk";
  static const String detailRiwayatPelayanan = "/detail_riwayat_pelayanan";
  static const String myLayanan = "/my_layanan";
  static const String tambahLayanan = "/tambah_layanan";
  static const String editLayanan = "/edit_layanan";
  static const String detailProfil = "/detail_profil";
  static const String updateProfil = "/update_profil";
  static const String requestUbahPassword = "/request_ubah_password";
  static const String checkOtp = "/check_otp";
  static const String ubahPasswordOtp = "/ubah_password_otp";

  static final Map<String, Widget Function(BuildContext)> routes = {
    main: (context) => const AuthLayout(),
    layanan: (context) => const SemuaLayananPage(),
    hasilPencarian: (context) => const HasilPencarianPage(),
    lokasiTersimpan: (context) => const LokasiTersimpanPage(),
    favorit: (context) => const FavoritPage(),
    detailRiwayat: (context) => const DetailRiwayatPage(),
    detailBidan: (context) => const DetailBidanPage(),
    pesanBerhasil: (context) => const PesanBerhasilPage(),
    daftar: (context) => const DaftarPage(),
    daftarBerhasil: (context) => const DaftarBerhasilPage(),
    messages: (context) => const MessagesPage(),
    chatroom: (context) => const ChatroomPage(),
    profilBidan: (context) => const ProfilBidanPage(),
    updateProfilBidan: (context) => const UpdateProfilBidanPage(),
    orderMasuk: (context) => const OrderMasukPage(),
    detailRiwayatPelayanan: (context) => const DetailRiwayatPelayananPage(),
    myLayanan: (context) => const MyLayananPage(),
    tambahLayanan: (context) => const TambahLayananPage(),
    editLayanan: (context) => const EditLayananPage(),
    detailProfil: (context) => const DetailProfilPage(),
    updateProfil: (context) => const UpdateProfilPage(),
    requestUbahPassword: (context) => const RequestUbahPasswordPage(),
    checkOtp: (context) => const CheckOtpPage(),
    ubahPasswordOtp: (context) => const UbahPasswordOtpPage(),
  };
}
