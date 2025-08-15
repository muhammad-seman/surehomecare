import 'package:bidan_care/features/home/views/home_page.dart';
import 'package:bidan_care/features/profil/views/profil_page.dart';
import 'package:bidan_care/features/riwayat/views/riwayat_page.dart';
import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:bidan_care/shared/utils/app_helpers.dart';
import 'package:flutter/material.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _index = 0;
  bool _isFirstRender = true;

  final List<Widget> _pages = [
    const HomePage(),
    const RiwayatPage(),
    const ProfilPage(),
  ];

  final List<AppBar?> _appBars = [
    AppBar(
      elevation: 0,
      shadowColor: Colors.transparent,
      backgroundColor: AppColors.scaffoldBackground,
      toolbarHeight: 0,
    ),
    AppBar(
      title: const Text("Riwayat"),
    ),
    null
  ];

  void _setPageIndex(int index) {
    setState(() => _index = index);
  }

  @override
  void initState() {
    super.initState();
    AppHelpers.onInit(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_isFirstRender) {
      _index = ModalRoute.of(context)!.settings.arguments as int? ?? 0;
      _isFirstRender = false;
    }

    return Scaffold(
      appBar: _appBars[_index],
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.disabledColor,
        currentIndex: _index,
        onTap: _setPageIndex,
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            tooltip: "Home",
            activeIcon: Icon(Icons.home_rounded),
            icon: Icon(Icons.home_outlined),
          ),
          BottomNavigationBarItem(
            label: "Riwayat",
            tooltip: "Riwayat",
            activeIcon: Icon(Icons.receipt_rounded),
            icon: Icon(Icons.receipt_outlined),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            tooltip: "Profile",
            activeIcon: Icon(Icons.person_rounded),
            icon: Icon(Icons.person_outlined),
          ),
        ],
      ),
    );
  }
}
