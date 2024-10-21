

import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:nextseat/common/contains/Env.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/common/utils/Utils.dart';
import 'package:nextseat/data/db/ChatDb.dart';
import 'package:nextseat/data/exceptions/DataExceptions.dart';
import 'package:nextseat/data/repository/UserRepository.dart';
import 'package:nextseat/domain/model/ChatModel.dart';
import 'package:nextseat/domain/model/RoomModel.dart';
import 'package:nextseat/domain/model/UserModel.dart';
import 'package:nextseat/domain/repository/ChatRepositoryImpl.dart';
import 'package:nextseat/injection/injection.dart';

// MARK: - 채팅 Repository
@Singleton(as: ChatRepositoryImpl, env: [Env.DEV, Env.DEPLOY])
class ChatRepository implements ChatRepositoryImpl {
  // MARK: - 현재 채팅방 조회
  @override
  Future<RoomModel> getCurrentChatRoom() async {
    try {
      RoomModel? room = ChatDb().currentRoom;

      // 현재 채팅방이 없는 경우
      if(room == null) {
        // 채팅방 생성
        room = await createChatRoom(
          name: '채팅방_${DateTime.now().millisecondsSinceEpoch}'
        );

        // 채팅방 입장
        await joinChatRoom(roomId: room.id);

        return room;
      }

      return room;
    } catch (e, s) {
      Log.e(e, s);
      rethrow;
    }
  }

  // MARK: - 채팅방 생성
  @override
  Future<RoomModel> createChatRoom({required String name}) async {
    try {
      String? getIp = await Utils.getIPAddress();
      Log.d("[ ChatRepository: createChatRoom ] getIp: $getIp");

      UserModel myInfo = await UserRepository().getMyInfo();

      RoomModel createRoom = RoomModel.empty(
        name: name,
        number: DateTime.now().millisecondsSinceEpoch.toString(),
        ownerId: myInfo.id,
        joinUserList: [myInfo],
        isJoinAble: true,
        hostAddress: getIp,
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
        findAt: DateTime.now(),
      );

      ChatDb().addRoom(createRoom);

      return createRoom;
    } catch (e, s) {
    Log.e(e, s);
    rethrow;
    }
  }

  // MARK: - 채팅방 목록 조회
  @override
  Future<List<RoomModel>> getChatRoomList() async {
    try {
      List<RoomModel> tRoomList = [];

      // Id 중복 제거
      for (RoomModel room in ChatDb().roomList) {
        if (tRoomList.any((element) => element.id == room.id)) {
          continue;
        }

        tRoomList.add(room);
      }

      ChatDb().roomList = tRoomList;
      return tRoomList;
    } catch (e, s) {
      Log.e(e, s);
      rethrow;
    }
  }

  // MARK: - 채팅방 입장
  @override
  Future<bool> joinChatRoom({required String roomId}) async {
    try {
      RoomModel? room = ChatDb().roomList.firstWhereOrNull((element) => element.id == roomId);

      if (room == null) {
        return false;
      }

      // 채팅 목록 초기화
      ChatDb().clearChat();

      // 채팅방 입장
      ChatDb().joinRoom(room);
      return true;
    } catch (e, s) {
      Log.e(e, s);
      rethrow;
    }
  }

  // MARK: - 채팅방 퇴장
  @override
  Future<bool> leaveChatRoom() async {
    try {
      // 채팅 목록 초기화
      ChatDb().clearChat();

      // 채팅방 퇴장
      ChatDb().leaveRoom();
      return true;
    } catch (e, s) {
      Log.e(e, s);
      rethrow;
    }
  }

  // MARK: - 채팅 전송
  @override
  Future<bool> sendChatMessage({required String message}) async {
    try {
      RoomModel? room = ChatDb().currentRoom;
      if(room == null) {
        throw DataException("채팅방이 없습니다.");
      }

      UserModel myInfo = await UserRepository().getMyInfo();

      ChatModel chatModel = ChatModel.empty(
        roomId: room.id,
        userId: myInfo.id,
        message: message,
        createdAt: DateTime.now(),
      );

      // 채팅 전송
      await ChatDb().sendChat(chatModel);

      return true;
    } catch (e, s) {
      Log.e(e, s);
      rethrow;
    }
  }

  // MARK: - 채팅 목록 조회
  @override
  Future<List<ChatModel>> getChatMessageList() async {
    try {
      List<ChatModel> tChatList = [];

      // Id 중복 제거
      for (ChatModel chat in ChatDb().chatList) {
        if (tChatList.any((element) => element.id == chat.id)) {
          continue;
        }

        tChatList.add(chat);
      }

      ChatDb().chatList = tChatList;
      return tChatList;
    } catch (e, s) {
      Log.e(e, s);
      rethrow;
    }
  }
}