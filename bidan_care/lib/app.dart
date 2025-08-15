import 'package:bidan_care/core/viewmodels/auth_view_model.dart';
import 'package:bidan_care/core/viewmodels/bidan_view_model.dart';
import 'package:bidan_care/features/my_layanan/viewmodels/edit_layanan_view_model.dart';
import 'package:bidan_care/shared/viewmodels/layanan_view_model.dart';
import 'package:bidan_care/features/messages/viewmodels/message_view_model.dart';
import 'package:bidan_care/routes.dart';
import 'package:bidan_care/shared/styles/app_themes.dart';
import 'package:bidan_care/shared/viewmodels/profil_bidan_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BidanCareApp extends StatelessWidget {
  const BidanCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => BidanViewModel()),
        ChangeNotifierProvider(create: (context) => LayananViewModel()),
        ChangeNotifierProvider(create: (context) => MessageViewModel()),
        ChangeNotifierProvider(create: (context) => ProfilBidanViewModel()),
        ChangeNotifierProvider(create: (context) => EditLayananViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "iCare",
        theme: AppThemes.lightTheme,
        initialRoute: Routes.main,
        routes: Routes.routes,
      ),
    );
  }
}
