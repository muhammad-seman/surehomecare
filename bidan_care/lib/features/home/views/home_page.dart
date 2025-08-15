import 'dart:developer';

import 'package:bidan_care/core/models/bidan.dart';
import 'package:bidan_care/core/viewmodels/bidan_view_model.dart';
import 'package:bidan_care/features/home/views/viewmodels/recent_bidan_view_model.dart';
import 'package:bidan_care/routes.dart';
import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:bidan_care/shared/styles/app_shadows.dart';
import 'package:bidan_care/shared/styles/app_text_styles.dart';
import 'package:bidan_care/shared/widgets/default_image.dart';
import 'package:bidan_care/shared/widgets/messages_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RecentBidanViewModel(),
      child: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PageTitle(),
            Stack(
              children: [
                // _LayananView(),
                _RecentBidan(),
                _SearchContainer(),
              ],
            ),
            _BidanView(),
          ],
        ),
      ),
    );
  }
}

class _PageTitle extends StatelessWidget {
  const _PageTitle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(36, 8, 8, 42),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MessagesButton(),
          Text(
            "iCare",
            style: AppTextStyles.headlineLarge
                .apply(color: AppColors.primaryColor),
          ),
          const Text("For a caring mother"),
        ],
      ),
    );
  }
}

class _RecentBidan extends StatelessWidget {
  const _RecentBidan();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 48, 28, 27),
      margin: const EdgeInsets.only(top: 22),
      color: AppColors.secondaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Pemesanan terakhir",
            style: AppTextStyles.headlineSmall,
          ),
          const SizedBox(height: 12),
          FutureBuilder(
            future: context.read<RecentBidanViewModel>().getRecentBidan(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Row(
                  children: [
                    _LoadingLayananItem(),
                    _LoadingLayananItem(),
                    _LoadingLayananItem(),
                    _LoadingLayananItem(),
                  ],
                );
              }

              if (snapshot.hasError || !snapshot.hasData) {
                log("Error: ${snapshot.error}");
                log("Has data: ${snapshot.hasData}");
                // TODO: error view
                return const Text("Terjadi kesalahan");
              }

              List<Bidan> listBidan = snapshot.data!;
              if (listBidan.length > 4) {
                listBidan = listBidan.sublist(0, 4);
              }
              return Row(
                children: listBidan.map((bidan) {
                  return _RecentBidanItem(
                    bidan: bidan,
                    isFull: listBidan.length == 4,
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RecentBidanItem extends StatelessWidget {
  const _RecentBidanItem({
    required this.bidan,
    required this.isFull,
  });

  final Bidan bidan;
  final bool isFull;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: isFull ? 1 : 0,
      child: MaterialButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.detailBidan, arguments: bidan);
        },
        minWidth: 0,
        padding: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isFull ? 0 : 4),
          child: Column(
            children: [
              DefaultImage(
                borderRadius: 10,
                image: bidan.thumbnail,
                fit: BoxFit.cover,
                height: 56,
                width: 56,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 64,
                child: Text(
                  bidan.nama,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class _LayananView extends StatelessWidget {
//   const _LayananView();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.fromLTRB(28, 56, 28, 27),
//           margin: const EdgeInsets.only(top: 22),
//           color: AppColors.secondaryColor,
//           child: FutureBuilder(
//             future: context.read<LayananViewModel>().getTopLayanan(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Row(
//                   children: [
//                     _LoadingLayananItem(),
//                     _LoadingLayananItem(),
//                     _LoadingLayananItem(),
//                     _LoadingLayananItem(),
//                   ],
//                 );
//               }

//               if (snapshot.hasError || !snapshot.hasData) {
//                 log("Error: ${snapshot.error}");
//                 log("Has data: ${snapshot.hasData}");
//                 // TODO: error view
//                 return const Text("Terjadi kesalahan");
//               }

//               List<TopLayanan> listLayanan = snapshot.data!;
//               if (listLayanan.length > 4) {
//                 listLayanan = listLayanan.sublist(0, 4);
//               }
//               return Row(
//                 children: listLayanan.map((layanan) {
//                   return Expanded(child: LayananItem(layanan: layanan));
//                 }).toList(),
//               );
//             },
//           ),
//         ),
//         Align(
//           alignment: Alignment.centerRight,
//           child: TextButton(
//             onPressed: () => Navigator.pushNamed(context, Routes.layanan),
//             child: const Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text("Semua layanan"),
//                 Icon(
//                   Icons.keyboard_arrow_right,
//                   size: 18,
//                 ),
//               ],
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }

class _LoadingLayananItem extends StatelessWidget {
  const _LoadingLayananItem();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 56,
            width: 56,
          ),
          Container(
            color: Colors.white,
            width: 64,
            child: const Text(
              "",
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
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

  void _submitSearch() {
    final search = _searchController.text.trim();
    if (search.isEmpty) return;
    Navigator.pushNamed(
      context,
      Routes.hasilPencarian,
      arguments: search,
    ).then(_postSubmit);
  }

  void _postSubmit(_) {
    _searchController.text = "";
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: const EdgeInsets.only(left: 18),
      margin: const EdgeInsets.symmetric(horizontal: 21),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
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
    );
  }

  Material _buildSearchButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _submitSearch,
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

class _BidanView extends StatelessWidget {
  const _BidanView();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 32, bottom: 8, left: 20),
          child: Text(
            "Bidan di daerah Anda",
            style: AppTextStyles.headlineSmall,
          ),
        ),
        SizedBox(
          height: 270,
          child: FutureBuilder(
              future: context.read<BidanViewModel>().getBidan(),
              builder: (context, snapshot) {
                const scrollDirection = Axis.horizontal;
                const padding = EdgeInsets.symmetric(horizontal: 12);

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    scrollDirection: scrollDirection,
                    padding: padding,
                    itemCount: 3,
                    itemBuilder: (_, __) => const _LoadingBidanItem(),
                  );
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  log("Error: ${snapshot.error}");
                  log("Has data: ${snapshot.hasData}");
                  // TODO: error view
                  // TODO: empty view
                  return const Text("Terjadi kesalahan");
                }

                final listBidan = snapshot.data!;
                return ListView.builder(
                  scrollDirection: scrollDirection,
                  padding: padding,
                  itemCount: listBidan.length,
                  itemBuilder: (context, index) {
                    final bidan = listBidan[index];
                    return _BidanItem(bidan: bidan);
                  },
                );
              }),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _LoadingBidanItem extends StatelessWidget {
  const _LoadingBidanItem();

  @override
  Widget build(BuildContext context) {
    const double width = 180;

    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 135,
            width: width,
            decoration: BoxDecoration(
              color: AppColors.loadingColor,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          Container(
            width: width / 1.5,
            color: AppColors.loadingColor,
            margin: const EdgeInsets.only(top: 16, bottom: 4),
            child: Text(
              "",
              style: AppTextStyles.bodyLarge.apply(
                color: AppColors.loadingColor,
              ),
            ),
          ),
          Container(
            width: width,
            color: AppColors.loadingColor,
            child: Text(
              "",
              maxLines: 2,
              style: TextStyle(color: AppColors.loadingColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _BidanItem extends StatelessWidget {
  const _BidanItem({required this.bidan});
  final Bidan bidan;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.detailBidan,
          arguments: bidan,
        );
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IDEA: jumlah layanan
            DefaultImage(
              borderRadius: 20,
              image: bidan.thumbnail,
              fit: BoxFit.cover,
              height: 135,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 4),
              child: Text(
                bidan.nama,
                style: AppTextStyles.bodyLarge,
              ),
            ),
            Text(
              "${bidan.keterangan}\n",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.captionColor),
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Details",
                  style: TextStyle(color: AppColors.accentColor),
                ),
                Icon(
                  Icons.keyboard_arrow_right,
                  size: 18,
                  color: AppColors.accentColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
