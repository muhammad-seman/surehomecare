import 'dart:developer';

import 'package:bidan_care/features/messages/models/home_message.dart';
import 'package:bidan_care/features/messages/viewmodels/message_view_model.dart';
import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:bidan_care/shared/styles/app_text_styles.dart';
import 'package:bidan_care/shared/utils/app_helpers.dart';
import 'package:bidan_care/shared/widgets/default_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    final _ = context.select<MessageViewModel, bool>((viewModel) {
      return viewModel.hasUnreadMessages;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
      ),
      body: FutureBuilder(
        future: context.read<MessageViewModel>().getHomeMessage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: 3,
              itemBuilder: (_, __) => const _LoadingMessageItem(),
            );
          }
          if (snapshot.hasError || !snapshot.hasData) {
            log("Error: ${snapshot.error}");
            // TODO: error view
            return const Text("Terjadi kesalahan");
          }
          if (snapshot.data!.isEmpty) {
            // TODO: empty view
            return const Text("Data kosong");
          }

          final listHomeMessages = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: listHomeMessages.length,
            itemBuilder: (context, index) {
              final message = listHomeMessages[index];
              return _MessageItem(message: message);
            },
          );
        },
      ),
    );
  }
}

class _LoadingMessageItem extends StatelessWidget {
  const _LoadingMessageItem();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.loadingColor,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    color: AppColors.loadingColor,
                    margin: const EdgeInsets.only(bottom: 4),
                    child: const Text(
                      "",
                      style: AppTextStyles.bodyLarge,
                    ),
                  ),
                  Container(
                    width: 230,
                    color: AppColors.loadingColor,
                    child: const Text(""),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageItem extends StatelessWidget {
  const _MessageItem({required this.message});
  final HomeMessage message;

  @override
  Widget build(BuildContext context) {
    final prefix = message.isPengirim ? "Anda: " : "";

    return InkWell(
      onTap: () => AppHelpers.pushChatroom(context, message.oppose),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            _buildUnreadIcon(),
            DefaultImage(
              image: message.oppose.gambar,
              width: 50,
              height: 50,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.oppose.nama,
                      style: AppTextStyles.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "$prefix${message.isi}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Text(
              DateFormat("HH.mm").format(message.createdAt),
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnreadIcon() {
    if (message.isPengirim || message.tglBaca != null) return const SizedBox();
    return const Padding(
      padding: EdgeInsets.only(right: 12),
      child: Icon(
        Icons.circle,
        color: AppColors.primaryColor,
        size: 17,
      ),
    );
  }
}
