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

  // 전송 대기중인 채팅 메시지
  List<ChatModel> get pendingChatList => chatList.where((element) => element.isSendSuccess).toList();

  // MARK: - 전체 초기화
  Future<void> clear() async {
    chatList.clear();
    unreadMessageStreamController.add(false);
  }

  // MARK: - 채팅 초기화
  Future<void> clearChat() async {
    chatList.clear();
    unreadMessageStreamController.add(false);
  }

  // MARK: - 전송 완료 처리
  Future<void> completeSend(List<String> ids) async {
    for (var element in chatList) {
      if (ids.contains(element.id)) {
        element.isSendSuccess = true;
      }
    }
  }

  // MARK: - 채팅 전송
  Future<bool> sendChat(ChatModel chat) async {
    try {
      // 채팅 목록에 해당 chat Id가 없는 경우 추가
      if (!chatList.any((element) => element.id == chat.id)) {
        chatList.add(chat);
        unreadMessageStreamController.add(false);
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  // MARK: - 채팅 수신
  Future<bool> receiveChat(ChatModel chat) async {
    try {
      // 채팅 목록에 해당 chat Id가 없는 경우 추가
      if (!chatList.any((element) => element.id == chat.id)) {
        chatList.add(chat);
        unreadMessageStreamController.add(true);
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
