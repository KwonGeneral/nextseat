

import 'package:nextseat/domain/model/ChatModel.dart';
import 'package:nextseat/domain/model/RoomModel.dart';

// MARK: - 채팅 Impl
abstract class ChatRepositoryImpl {
  // MARK: - 채팅방 생성
  Future<RoomModel> createChatRoom({required String name});

  // MARK: - 채팅방 목록 조회
  Future<List<RoomModel>> getChatRoomList();

  // MARK: - 채팅방 입장
  Future<bool> joinChatRoom({required String roomId});

  // MARK: - 채팅방 퇴장
  Future<bool> leaveChatRoom();

  // MARK: - 채팅 전송
  Future<bool> sendChatMessage({required String message});

  // MARK: - 채팅 목록 조회
  Future<List<ChatModel>> getChatMessageList();

  // MARK: - 현재 채팅방 조회
  Future<RoomModel> getCurrentChatRoom();
}