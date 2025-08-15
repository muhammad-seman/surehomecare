import 'package:bidan_care/features/bidan_home/views/bidan_home_page.dart';
import 'package:bidan_care/features/messages/viewmodels/message_view_model.dart';
import 'package:bidan_care/features/riwayat_pelayanan/views/riwayat_pelayanan_page.dart';
import 'package:bidan_care/routes.dart';
import 'package:bidan_care/shared/models/bidan_order.dart';
import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:bidan_care/shared/viewmodels/profil_bidan_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BidanMainLayout extends StatefulWidget {
  const BidanMainLayout({super.key});

  @override
  State<BidanMainLayout> createState() => _BidanMainLayoutState();
}

class _BidanMainLayoutState extends State<BidanMainLayout> {
  int _index = 0;
  bool _hasNewOrder = false;

  final List<Widget> _pages = [
    // TODO: riwayat pelayanan
    const BidanHomePage(),
    const RiwayatPelayananPage(),
  ];

  final List<AppBar?> _appBars = [
    null,
    AppBar(
      title: const Text("Riwayat Pelayanan"),
    ),
  ];

  void _setPageIndex(int index) {
    setState(() => _index = index);
  }

  _onOrder(BidanOrder order) {
    if (_hasNewOrder) return;
    _hasNewOrder = true;
    Navigator.pushNamed(context, Routes.orderMasuk, arguments: order)
        .then((v) => _postOnOrder(v, order));
  }

  _postOnOrder(Object? value, BidanOrder order) {
    _hasNewOrder = false;
    String? status;
    if (value == null || value == false) status = "ditolak";
    if (value == true) status = "ongoing";

    final viewModel = context.read<ProfilBidanViewModel>();
    if (status != null) viewModel.updateOrderStatus(order.id, status);
  }

  @override
  void initState() {
    super.initState();
    context.read<MessageViewModel>().onInit(onOrder: _onOrder);
  }

  @override
  Widget build(BuildContext context) {
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
        ],
      ),
    );
  }
}
