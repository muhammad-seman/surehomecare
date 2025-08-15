import 'dart:convert';
import 'dart:developer';

import 'package:bidan_care/core/utils/app_constants.dart';
import 'package:bidan_care/core/utils/auth_helper.dart';
import 'package:bidan_care/features/messages/models/abstract_message.dart';
import 'package:bidan_care/features/messages/models/home_message.dart';
import 'package:bidan_care/features/messages/models/message.dart';
import 'package:bidan_care/features/messages/models/oppose_user.dart';
import 'package:bidan_care/features/messages/models/send_message.dart';
import 'package:bidan_care/shared/models/bidan_order.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MessageViewModel extends ChangeNotifier {
  String get _endpoint => "${AppConstants.baseUrl}/api/message";

  bool _watchMessages = false;
  bool _hasUnreadMessages = false;
  OpposeUser? _opposeUser;
  List<AbstractMessage> _listMessages = [];
  Function(BidanOrder order)? _onOrder;

  bool get hasUnreadMessages => _hasUnreadMessages;
  List<AbstractMessage> get listMessages => _listMessages;
  OpposeUser? get opposeUser => _opposeUser;

  set opposeUser(OpposeUser? user) {
    _opposeUser = user;
    if (_opposeUser != null) _getFullChatroomMessages();
  }

  void onLeaveRoom() {
    _opposeUser = null;
    _listMessages = [];
  }

  void onLogout() {
    _watchMessages = false;
    _listMessages = [];
    _onOrder = null;
  }

  void onInit({Function(BidanOrder order)? onOrder}) {
    _watchMessages = true;
    _onOrder = onOrder;
    checkMessages();
  }

  Future checkMessages() async {
    if (!_watchMessages) return;
    try {
      _opposeUser != null
          ? await _checkChatroomMessages()
          : await _backgkrouondCheck();
    } catch (e) {
      log(e.toString());
    }
    await Future.delayed(const Duration(seconds: 1));
    checkMessages();
  }

  Future _backgkrouondCheck() async {
    log("Checking messages...");
    final response = await http.get(
      Uri.parse(_endpoint),
      headers: {"Authorization": "Bearer ${AuthHelper.token}"},
    );
    if (response.statusCode != 200) {
      log("Failed checking messages: ${response.body}");
      return;
    }
    final body = jsonDecode(response.body);
    _hasUnreadMessages = body["hasUnread"];

    final bidanOrderJson = body["bidanOrder"];
    final bidanOrder =
        bidanOrderJson != null ? BidanOrder.fromJson(bidanOrderJson) : null;
    if (bidanOrder != null && _onOrder != null) {
      _onOrder!(bidanOrder);
    }
    notifyListeners();
  }

  Future _checkChatroomMessages() async {
    log("Checking chatroom messages...");
    final response = await http.get(
      Uri.parse("$_endpoint/chatroom/${_opposeUser!.id}"),
      headers: {"Authorization": "Bearer ${AuthHelper.token}"},
    );
    if (response.statusCode != 200) throw Exception("API Error");
    final data = jsonDecode(response.body)["data"] as List;
    final newMessages = data.map((e) => Message.fromJson(e)).toList();
    _readMessages();

    final oldLength = _listMessages.length;
    _listMessages.addAll(newMessages);
    final newLength = _listMessages.length;
    if (oldLength != newLength) notifyListeners();
  }

  Future _readMessages() async {
    final response = await http.put(
      Uri.parse("$_endpoint/read/${opposeUser!.id}"),
      headers: {"Authorization": "Bearer ${AuthHelper.token}"},
    );
    if (response.statusCode != 200) throw Exception("API Error");
  }

  Future<List<HomeMessage>> getHomeMessage() async {
    final response = await http.get(
      Uri.parse("$_endpoint/home"),
      headers: {"Authorization": "Bearer ${AuthHelper.token}"},
    );
    log("Get home messages: ${response.body}");
    if (response.statusCode != 200) throw Exception("API Error");
    final data = jsonDecode(response.body)["data"] as List;
    return data.map((e) => HomeMessage.fromJson(e)).toList();
  }

  Future sendNewMessage(String isi) async {
    final message = SendMessage(
      isi: isi,
      penerima: _opposeUser!.id,
    );
    final index = _listMessages.length;
    _listMessages.add(message);
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse("$_endpoint/send"),
        headers: {
          "Authorization": "Bearer ${AuthHelper.token}",
          "Content-Type": "application/json"
        },
        body: message.toJson(),
      );
      log("Send new message: ${response.body}");
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body)["data"];
        listMessages[index] = Message.fromJson(data);
        notifyListeners();
        return;
      }
      (listMessages[index] as SendMessage).isFailed = true;
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future _getFullChatroomMessages() async {
    final response = await http.get(
      Uri.parse("$_endpoint/full_chatroom/${_opposeUser!.id}"),
      headers: {"Authorization": "Bearer ${AuthHelper.token}"},
    );
    log("Get full chatroom messages: ${response.body}");
    if (response.statusCode != 200) throw Exception("API Error");
    final data = jsonDecode(response.body)["data"] as List;
    final newMessages = data.map((e) => Message.fromJson(e)).toList();
    _listMessages.addAll(newMessages);
    notifyListeners();
  }
}
