import 'dart:developer';

import 'package:bidan_care/core/viewmodels/bidan_view_model.dart';
import 'package:bidan_care/features/hasil_pencarian/models/filter_item_args.dart';
import 'package:bidan_care/routes.dart';
import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:bidan_care/shared/styles/app_shadows.dart';
import 'package:bidan_care/shared/widgets/bidan_item.dart';
import 'package:bidan_care/shared/widgets/loading_bidan_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HasilPencarianPage extends StatelessWidget {
  const HasilPencarianPage({super.key});

  @override
  Widget build(BuildContext context) {
    final search = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const _SearchContainer(),
              // IDEA: filter
              // _FilterContainer(),
              _BidanListView(search),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchContainer extends StatefulWidget {
  const _SearchContainer();

  @override
  State<_SearchContainer> createState() => _SearchContainerState();
}

class _SearchContainerState extends State<_SearchContainer> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        Expanded(
          child: Container(
            height: 45,
            padding: const EdgeInsets.only(left: 18),
            margin: const EdgeInsets.fromLTRB(0, 12, 21, 12),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: AppShadows.small,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSearchField(),
                const VerticalDivider(
                  indent: 8,
                  endIndent: 8,
                  width: 1,
                ),
                _buildSearchButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Material _buildSearchButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          final search = _searchController.text.trim();
          if (search.isEmpty) return;
          Navigator.pushReplacementNamed(
            context,
            Routes.hasilPencarian,
            arguments: search,
          );
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Icon(
            Icons.search,
            color: AppColors.dividerColor,
          ),
        ),
      ),
    );
  }

  Expanded _buildSearchField() {
    return Expanded(
      child: Center(
        child: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: "Cari bidan / layanan...",
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8),
            hintStyle: TextStyle(
              fontWeight: FontWeight.normal,
              color: AppColors.dividerColor,
            ),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class _FilterContainer extends StatelessWidget {
  const _FilterContainer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.secondaryColor,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            children: [
              _FilterItem(
                icon: Icons.location_on,
                items: dummyArgs,
                hint: "Pilih lokasi",
                onTap: () {
                  // TODO: show dialog
                },
              ),
              const SizedBox(width: 12),
              const _FilterItem(
                icon: Icons.cleaning_services,
                items: dummyArgs,
                hint: "Pilih layanan",
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 80,
            height: 35,
            child: TextButton(
              onPressed: () {
                // TODO: clear filter
              },
              child: const Text("Clear filter"),
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterItem extends StatefulWidget {
  const _FilterItem({
    required this.icon,
    required this.items,
    required this.hint,
    this.onTap,
  });

  final IconData icon;
  final List<FilterItemArgs> items;
  final String hint;
  final Function()? onTap;

  @override
  State<_FilterItem> createState() => _FilterItemState();
}

class _FilterItemState extends State<_FilterItem> {
  String? _value;

  void _onChanged(String? value) {
    if (widget.onTap != null) return;
    setState(() => _value = value);
    // TODO: update viewmodel
  }

  void _onTap() {
    if (widget.onTap == null) return;
    Navigator.pop(context);
    widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    final items = [FilterItemArgs(value: null, text: widget.hint)];
    items.addAll(widget.items);

    return Expanded(
      child: DropdownButtonFormField<String>(
        value: _value,
        decoration: InputDecoration(
          hintText: widget.hint,
          prefixIcon: Icon(
            widget.icon,
            size: 20,
            color: AppColors.accentColor,
          ),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        onChanged: _onChanged,
        onTap: _onTap,
        icon: const Icon(
          Icons.arrow_drop_down,
          size: 20,
        ),
        items: items.map((args) {
          return DropdownMenuItem<String>(
            value: args.value,
            child: Text(
              args.text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _BidanListView extends StatelessWidget {
  const _BidanListView(this.search);
  final String search;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<BidanViewModel>().searchBidan(search),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (_, __) => const LoadingBidanItem(),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          // TODO: error view
          log(snapshot.error.toString());
          return const Text("Terjadi kesalahan");
        }

        if (snapshot.data!.isEmpty) {
          // TODO: empty view
          return const Center(
            child: Text("Tidak ada hasil pencarian"),
          );
        }

        final listBidan = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: listBidan.length,
          itemBuilder: (context, index) {
            final bidan = listBidan[index];
            return BidanItem(bidan: bidan);
          },
        );
      },
    );
  }
}
