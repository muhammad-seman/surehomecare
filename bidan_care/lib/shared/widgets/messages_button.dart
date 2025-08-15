import 'package:bidan_care/features/messages/viewmodels/message_view_model.dart';
import 'package:bidan_care/routes.dart';
import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessagesButton extends StatelessWidget {
  const MessagesButton({super.key});

  @override
  Widget build(BuildContext context) {
    final hasUnread = context.select<MessageViewModel, bool>((viewModel) {
      return viewModel.hasUnreadMessages;
    });

    return Align(
      alignment: Alignment.topRight,
      child: Stack(
        children: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, Routes.messages),
            icon: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.chat_outlined),
            ),
          ),
          hasUnread
              ? const Positioned(
                  top: 13,
                  right: 13,
                  child: Icon(
                    Icons.circle,
                    size: 10,
                    color: AppColors.accentColor,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
