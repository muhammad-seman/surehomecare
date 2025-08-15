import 'package:bidan_care/core/viewmodels/auth_view_model.dart';
import 'package:bidan_care/routes.dart';
import 'package:bidan_care/shared/models/profile_action.dart';
import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:bidan_care/shared/styles/app_shadows.dart';
import 'package:bidan_care/shared/utils/app_helpers.dart';
import 'package:bidan_care/shared/widgets/alert_modal.dart';
import 'package:bidan_care/shared/widgets/profile_actions_container.dart';
import 'package:bidan_care/shared/widgets/profile_page_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthViewModel>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Column(
        children: [
          ProfilePageTitle(),
          _PrimaryActions(),
          _OtherActions(),
        ],
      ),
    );
  }
}

class _PrimaryActions extends StatelessWidget {
  const _PrimaryActions();

  static late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Container(
      color: AppColors.secondaryColor,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildActionButton(Icons.favorite, "Bidan\nFavorit", Routes.favorit),
          const SizedBox(width: 18),
          _buildActionButton(Icons.person, "Edit\nProfil", Routes.detailProfil),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String text, String route) {
    return Container(
      height: 90,
      width: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: AppShadows.medium,
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pushNamed(_context, route),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: AppColors.primaryColor,
                  size: 28,
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.primaryColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OtherActions extends StatelessWidget {
  const _OtherActions();

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
    // TODO: action onpressed
    final List<ProfileAction> listActions = [
      // ActionItem(
      //   icon: Icons.person,
      //   title: "Edit profil",
      //   onPressed: () {},
      // ),
      // ActionItem(
      //   icon: Icons.lock_outline,
      //   title: "Ubah password",
      //   onPressed: () {},
      // ),
      ProfileAction(
        icon: Icons.logout,
        title: "Logout",
        onPressed: _onLogout,
      ),
    ];
    return ProfileActionsContainer(
      listActions: listActions,
    );
  }
}
