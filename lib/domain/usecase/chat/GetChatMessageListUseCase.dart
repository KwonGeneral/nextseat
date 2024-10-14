

import 'package:injectable/injectable.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/domain/model/ChatModel.dart';
import 'package:nextseat/domain/model/RoomModel.dart';
import 'package:nextseat/domain/repository/ChatRepositoryImpl.dart';

// MARK: - 채팅 목록 조회 UseCase
@singleton
class GetChatMessageListUseCase {
  final ChatRepositoryImpl chatRepository;

  GetChatMessageListUseCase(this.chatRepository);

  Future<List<ChatModel>> call({String? roomId}) async {
    try {
      String? currentRoomId = roomId;
      if(currentRoomId == null) {
        // 현재 채팅방 조회
        RoomModel? currentRoom = await chatRepository.getCurrentChatRoom();
        if(currentRoom == null) {
          return [];
        }

        currentRoomId = currentRoom.id;
      }

      return await chatRepository.getChatMessageList(roomId: currentRoomId);
    } catch(e, s) {
      Log.e(e, s);
      return [];
    }
  }
}