import 'package:bidan_care/features/messages/models/abstract_message.dart';
import 'package:bidan_care/features/messages/models/message.dart';
import 'package:bidan_care/features/messages/models/oppose_user.dart';
import 'package:bidan_care/features/messages/models/send_message.dart';
import 'package:bidan_care/features/messages/viewmodels/chatroom_view_model.dart';
import 'package:bidan_care/features/messages/viewmodels/message_view_model.dart';
import 'package:bidan_care/shared/styles/app_colors.dart';
import 'package:bidan_care/shared/widgets/default_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatroomPage extends StatefulWidget {
  const ChatroomPage({super.key});

  @override
  State<ChatroomPage> createState() => _ChatroomPageState();
}

class _ChatroomPageState extends State<ChatroomPage> {
  @override
  void dispose() {
    super.dispose();
    context.read<ChatroomViewModel>().scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final opposeUser = ModalRoute.of(context)!.settings.arguments as OpposeUser;
    context.read<MessageViewModel>().opposeUser = opposeUser;

    return ChangeNotifierProvider(
      create: (context) => ChatroomViewModel(),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Row(
              children: [
                DefaultImage(
                  image: opposeUser.gambar,
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 12),
                Text(opposeUser.nama),
              ],
            ),
          ),
          body: const Padding(
            padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              children: [
                _MessagesListView(),
                SizedBox(height: 4),
                _SendSection(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MessagesListView extends StatelessWidget {
  const _MessagesListView();

  static late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    final listMessages = context.watch<MessageViewModel>().listMessages;
    WidgetsBinding.instance.addPostFrameCallback(_scrollToBottom);
    return Expanded(
      child: ListView.builder(
        controller: context.read<ChatroomViewModel>().scrollController,
        itemCount: listMessages.length,
        itemBuilder: (context, index) {
          final message = listMessages[index];
          return _MessageItem(message: message);
        },
      ),
    );
  }

  void _scrollToBottom(_) {
    final scrollController =
        _context.read<ChatroomViewModel>().scrollController;
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }
}

class _MessageItem extends StatelessWidget {
  const _MessageItem({required this.message});
  final AbstractMessage message;

  MessageStatus get _status {
    if (message is Message) return MessageStatus.sent;
    final newMessage = message as SendMessage;
    if (newMessage.isFailed) return MessageStatus.failed;
    return MessageStatus.pending;
  }

  IconData get iconData {
    if (_status == MessageStatus.pending) return Icons.access_time;
    if (_status == MessageStatus.failed) return Icons.error_outline;
    return Icons.done;
  }

  Color get detailColor {
    return message.isPengirim ? Colors.white60 : Colors.black45;
  }

  String? get waktu {
    if (message is SendMessage) return null;
    return DateFormat("HH.mm").format((message as Message).createdAt);
  }

  @override
  Widget build(BuildContext context) {
    final isPengirim = message.isPengirim;
    final alignment = isPengirim ? Alignment.centerRight : Alignment.centerLeft;
    final double marginL = isPengirim ? 40 : 0;
    const double marginT = 7;
    final double marginR = isPengirim ? 0 : 40;
    const double marginB = 0;

    final backgroundColor =
        isPengirim ? AppColors.accentColor.withOpacity(.7) : Colors.white;

    return Align(
      alignment: alignment,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        margin: EdgeInsets.fromLTRB(marginL, marginT, marginR, marginB),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: backgroundColor),
        child: Column(
          crossAxisAlignment:
              isPengirim ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.isi,
              style: TextStyle(
                color: isPengirim ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  waktu ?? "",
                  style: TextStyle(fontSize: 10, color: detailColor),
                ),
                const SizedBox(width: 5),
                isPengirim
                    ? Icon(
                        iconData,
                        color: detailColor,
                        size: 17,
                      )
                    : const SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SendSection extends StatefulWidget {
  const _SendSection();

  @override
  State<_SendSection> createState() => _SendSectionState();
}

class _SendSectionState extends State<_SendSection> {
  final _pesanController = TextEditingController();

  void _jumpToEnd() {
    final controller = context.read<ChatroomViewModel>().scrollController;
    controller.jumpTo(controller.position.maxScrollExtent);
  }

  void kirimPesan() {
    final isi = _pesanController.text.trim();
    if (isi.isEmpty) return;
    context
        .read<MessageViewModel>()
        .sendNewMessage(isi)
        .then((_) => _jumpToEnd());
    _pesanController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 150),
            child: TextField(
              controller: _pesanController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              decoration: buildInputDecoration(),
            ),
          ),
        ),
        const SizedBox(width: 5),
        SizedBox(
          width: 50,
          child: AspectRatio(
            aspectRatio: 1,
            child: MaterialButton(
              onPressed: kirimPesan,
              minWidth: 0,
              padding: EdgeInsets.zero,
              color: AppColors.primaryColor,
              elevation: 0,
              highlightElevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white60,
              ),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration buildInputDecoration() {
    return InputDecoration(
      hintText: "Ketik pesan...",
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(
        fontSize: 16,
        color: Colors.grey,
        fontWeight: FontWeight.normal,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      enabledBorder: buildInputBorder(),
      focusedBorder: buildInputBorder(),
    );
  }

  OutlineInputBorder buildInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    );
  }
}

enum MessageStatus { pending, failed, sent }
