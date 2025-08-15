import 'dart:developer';

import 'package:bidan_care/core/viewmodels/auth_view_model.dart';
import 'package:bidan_care/shared/viewmodels/profil_bidan_view_model.dart';
import 'package:bidan_care/routes.dart';
import 'package:bidan_care/shared/models/profile_action.dart';
import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:bidan_care/shared/utils/app_helpers.dart';
import 'package:bidan_care/shared/widgets/alert_modal.dart';
import 'package:bidan_care/shared/widgets/messages_button.dart';
import 'package:bidan_care/shared/widgets/profile_actions_container.dart';
import 'package:bidan_care/shared/widgets/profile_page_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BidanHomePage extends StatelessWidget {
  const BidanHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                ProfilePageTitle(
                  margin: EdgeInsets.symmetric(vertical: 24),
                ),
                _Statistik(),
                _PageActions(),
              ],
            ),
          ),
          MessagesButton(),
        ],
      ),
    );
  }
}

class _Statistik extends StatelessWidget {
  const _Statistik();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<ProfilBidanViewModel>().getStatistics(),
      builder: (context, snapshot) {
        const largerTextStyle = TextStyle(fontSize: 18);
        String jlhPelayanan = "-";
        String pendapatan = "-";

        if (snapshot.hasError) {
          log(snapshot.error.toString());
        }

        if (snapshot.hasData) {
          final statistik = snapshot.data!;
          jlhPelayanan = statistik.jlhPelayanan.toString();
          pendapatan = AppHelpers.formatHarga(statistik.pendapatan);
        }

        return Column(
          children: [
            const Row(
              children: [
                Icon(
                  Icons.history,
                  size: 20,
                  color: AppColors.accentColor,
                ),
                SizedBox(width: 8),
                Text(
                  "30 hari terakhir",
                  style: TextStyle(color: AppColors.accentColor),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "$jlhPelayanan ",
                        style: largerTextStyle,
                      ),
                      const Text("Pelayanan"),
                    ],
                  ),
                  const VerticalDivider(width: 36),
                  Text(
                    pendapatan,
                    style: largerTextStyle,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PageActions extends StatelessWidget {
  const _PageActions();

  static late BuildContext _context;

  void _onLogout() {
    showDialog(
      context: _context,
      builder: (context) {
        return const AlertModal(
          title: "Apakah Anda ingin logout?",
          confirmText: "Logout",
        );
      },
    ).then((konfirmasi) {
      if (konfirmasi == true) {
        _context.read<AuthViewModel>().logout();
        AppHelpers.onLogout(_context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    final List<ProfileAction> listActions = [
      ProfileAction(
        icon: Icons.store_outlined,
        title: "Profil Bidan",
        onPressed: () => Navigator.pushNamed(context, Routes.profilBidan),
      ),
      ProfileAction(
        icon: Icons.cleaning_services_outlined,
        title: "Layanan Anda",
        onPressed: () => Navigator.pushNamed(context, Routes.myLayanan),
      ),
      ProfileAction(
        icon: Icons.logout,
        title: "Logout",
        onPressed: _onLogout,
      ),
    ];
    return ProfileActionsContainer(
      listActions: listActions,
      margin: const EdgeInsets.symmetric(vertical: 21),
    );
  }
}
