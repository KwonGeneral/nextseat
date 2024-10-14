

import 'package:injectable/injectable.dart';
import 'package:nextseat/common/contains/Env.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/data/exceptions/DataExceptions.dart';
import 'package:nextseat/domain/model/ChatModel.dart';
import 'package:nextseat/domain/model/RoomModel.dart';
import 'package:nextseat/domain/repository/ChatRepositoryImpl.dart';

// MARK: - 채팅 Repository
@Singleton(as: ChatRepositoryImpl, env: [Env.DEV, Env.DEPLOY])
class ChatRepository implements ChatRepositoryImpl {
  // MARK: - 채팅방 생성
  @override
  Future<RoomModel> createChatRoom({required String name}) async {
    try {

      throw DataException("채팅방 생성 실패");
    } catch (e, s) {
    Log.e(e, s);
    rethrow;
    }
  }

  // MARK: - 채팅방 목록 조회
  @override
  Future<List<RoomModel>> getChatRoomList() async {
    try {
      throw DataException("채팅방 목록 조회 실패");
    } catch (e, s) {
      Log.e(e, s);
      rethrow;
    }
  }

  // MARK: - 채팅방 입장
  @override
  Future<bool> joinChatRoom({required String roomId}) async {
    try {
      throw DataException("채팅방 입장 실패");
    } catch (e, s) {
      Log.e(e, s);
      rethrow;
    }
  }

  // MARK: - 채팅 전송
  @override
  Future<bool> sendChatMessage({required String roomId, required String message}) async {
    try {
      throw DataException("채팅 전송 실패");
    } catch (e, s) {
      Log.e(e, s);
      rethrow;
    }
  }

  // MARK: - 채팅 목록 조회
  @override
  Future<List<ChatModel>> getChatMessageList({required String roomId}) {
    try {
      throw DataException("채팅 목록 조회 실패");
    } catch (e, s) {
      Log.e(e, s);
      rethrow;
    }
  }

  // MARK: - 현재 채팅방 조회
  @override
  Future<RoomModel?> getCurrentChatRoom() async {
    try {
      throw DataException("현재 채팅방 조회 실패");
    } catch (e, s) {
      Log.e(e, s);
      rethrow;
    }
  }
}