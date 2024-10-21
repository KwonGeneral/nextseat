// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'dart:async';

import 'package:nextseat/domain/model/ChatModel.dart';
import 'package:nextseat/domain/model/RoomModel.dart';

// MARK: - 채팅 DB (휘발성)
class ChatDb {
  static final ChatDb _instance = ChatDb._internal();

  factory ChatDb() => _instance;
  ChatDb._internal();

  // 읽지않은 메세지 여부 스트림
  final StreamController<bool> unreadMessageStreamController = StreamController<bool>.broadcast();

  // 채팅방 목록
  List<RoomModel> roomList = [];

  // 현재까지 채팅 메시지
  List<ChatModel> chatList = [];

  // 현재 채팅방
  RoomModel? currentRoom;

  // MARK: - 전체 초기화
  Future<void> clear() async {
    chatList.clear();
    unreadMessageStreamController.add(false);
  }

  // MARK: - 채팅방 입장
  Future<bool> joinRoom(RoomModel room) async {
    try {
      currentRoom = room;
      return true;
    } catch (e) {
      return false;
    }
  }

  // MARK: - 채팅방 퇴장
  Future<bool> leaveRoom() async {
    try {
      currentRoom = null;
      return true;
    } catch (e) {
      return false;
    }
  }

  // MARK: - 채팅방 목록 추가
  Future<bool> addRoom(RoomModel room) async {
    try {
      if (roomList.any((element) => element.id == room.id)) {
        return false;
      }

      roomList.add(room);
      return true;
    } catch (e) {
      return false;
    }
  }

  // MARK: - 채팅방 목록 제거
  Future<bool> removeRoom(String id) async {
    try {
      roomList.removeWhere((element) => element.id == id);
      return true;
    } catch (e) {
      return false;
    }
  }

  // MARK: - 채팅 초기화
  Future<void> clearChat() async {
    chatList.clear();
    unreadMessageStreamController.add(false);
  }

  // MARK: - 채팅 전송
  Future<bool> sendChat(ChatModel chat) async {
    try {
      chatList.add(chat);
      unreadMessageStreamController.add(false);
      return true;
    } catch (e) {
      return false;
    }
  }

  // MARK: - 채팅 수신
  Future<bool> receiveChat(ChatModel chat) async {
    try {
      chatList.add(chat);
      unreadMessageStreamController.add(true);
      return true;
    } catch (e) {
      return false;
    }
  }
}
