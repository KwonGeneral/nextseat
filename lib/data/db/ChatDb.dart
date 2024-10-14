// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'dart:async';

import 'package:nextseat/domain/model/ChatModel.dart';

// MARK: - 채팅 DB (휘발성)
class ChatDb {
  static final ChatDb _instance = ChatDb._internal();

  factory ChatDb() => _instance;
  ChatDb._internal();

  // 읽지않은 메세지 여부 스트림
  final StreamController<bool> unreadMessageStreamController = StreamController<bool>.broadcast();

  // 현재까지 채팅 메시지
  List<ChatModel> chatList = [];

  // MARK: - 전체 초기화
  Future<void> clear() async {
    chatList.clear();
    unreadMessageStreamController.add(false);
  }

  // 채팅 전송
  Future<void> sendChat(ChatModel chat) async {
    chatList.add(chat);
    unreadMessageStreamController.add(false);
  }

  // 채팅 수신
  Future<void> receiveChat(ChatModel chat) async {
    chatList.add(chat);
    unreadMessageStreamController.add(true);
  }
}
